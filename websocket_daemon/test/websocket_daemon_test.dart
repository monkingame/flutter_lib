import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:websocket_daemon/websocket_daemon.dart';

/// Waits until [condition] becomes true or [timeout] elapses.
Future<void> _waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 6),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('timed out waiting for condition');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

/// Starts a local websocket server. For each accepted connection,
/// [onConnect] is invoked with the socket and the connection index
/// (starting at 0).
Future<HttpServer> _startServer(void Function(WebSocket ws, int index) onConnect) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  var index = 0;
  server.listen((HttpRequest request) async {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      final ws = await WebSocketTransformer.upgrade(request);
      final current = index++;
      onConnect(ws, current);
    } else {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
    }
  });
  return server;
}

void main() {
  test('receives data from server and notifies listeners', () async {
    final server = await _startServer((ws, index) {
      ws.add('hello daemon');
    });

    final daemon = ModelDaemonWebSocket(urlServer: 'ws://127.0.0.1:${server.port}');
    var notifyCount = 0;
    daemon.addListener(() => notifyCount++);

    daemon.initConnection();
    await _waitFor(() => daemon.data == 'hello daemon');

    expect(daemon.data, 'hello daemon');
    expect(daemon.serverAvaliable, isTrue);
    expect(notifyCount, greaterThan(0));

    daemon.close();
    await server.close(force: true);
  });

  test('dropData clears data and notifies', () async {
    final server = await _startServer((ws, index) {
      ws.add('keep me');
    });

    final daemon = ModelDaemonWebSocket(urlServer: 'ws://127.0.0.1:${server.port}');
    daemon.initConnection();
    await _waitFor(() => daemon.data == 'keep me');

    daemon.dropData();
    expect(daemon.data, isNull);

    daemon.close();
    await server.close(force: true);
  });

  test('sendMessage delivers message to server', () async {
    final received = <String>[];
    final serverConnected = Completer<void>();
    final server = await _startServer((ws, index) {
      serverConnected.complete();
      ws.listen((dynamic data) => received.add(data.toString()));
    });

    final daemon = ModelDaemonWebSocket(urlServer: 'ws://127.0.0.1:${server.port}');
    daemon.initConnection();

    await serverConnected.future.timeout(const Duration(seconds: 5));
    daemon.sendMessage('ping from daemon');
    await _waitFor(() => received.contains('ping from daemon'));

    expect(received, contains('ping from daemon'));

    daemon.close();
    await server.close(force: true);
  });

  test('reconnects automatically when server closes the connection', () async {
    var connections = 0;
    final server = await _startServer((ws, index) {
      connections++;
      // First connection drops immediately, forcing the daemon to reconnect.
      if (index == 0) ws.close();
    });

    final daemon = ModelDaemonWebSocket(
      urlServer: 'ws://127.0.0.1:${server.port}',
      reconectMilliseconds: 100,
    );
    daemon.initConnection();

    await _waitFor(() => connections >= 2);
    await _waitFor(() => daemon.serverAvaliable);

    daemon.close();
    await server.close(force: true);
  });

  test('close stops reconnection and disposes', () async {
    var connections = 0;
    final server = await _startServer((ws, index) {
      connections++;
      ws.close();
    });

    final daemon = ModelDaemonWebSocket(
      urlServer: 'ws://127.0.0.1:${server.port}',
      reconectMilliseconds: 100,
    );
    var notifyCount = 0;
    daemon.addListener(() => notifyCount++);
    daemon.initConnection();
    await _waitFor(() => connections >= 1);

    final notifyCountBeforeClose = notifyCount;
    daemon.close();

    // Give a couple of reconnect intervals a chance to run after close.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    expect(notifyCount, notifyCountBeforeClose);
    expect(daemon.serverAvaliable, isFalse);

    await server.close(force: true);
  });
}
