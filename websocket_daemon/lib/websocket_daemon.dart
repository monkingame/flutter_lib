library websocket_daemon;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ModelDaemonWebSocket extends ChangeNotifier {
  IOWebSocketChannel _channel;
  Stream _stream;
  StreamSubscription _subScription;

  /// reconnect interval: milliseconds
  final int reconectMilliseconds;

  final String urlServer;

  dynamic _data;

  ModelDaemonWebSocket({
    @required this.urlServer,
    this.reconectMilliseconds = 1000,
  });

  /// connect to server
  void initConnection() {
    _channel = IOWebSocketChannel.connect(urlServer);

    _listenWebSocket();
  }

  _listenWebSocket() {
    _stream = _channel.stream.asBroadcastStream();

    _subScription = _stream.listen(
      _onData,
      onDone: () {
        _closeConnect();
        _reConnect();
        notifyListeners();
      },
      onError: (err) {
        _closeConnect();
        _reConnect();
        notifyListeners();
      },
      cancelOnError: true,
    );

    // NOTE:如果在此调用 notifyListeners()
    // 可能会产生错误： setState() or markNeedsBuild() called during build.
    // 原因是Widget还未构建好，但要求重建的命令就下达了
    // notifyListeners();
  }

  void _onData(data) {
    _data = data;

    notifyListeners();
  }

  dynamic get data => _data;

  void dropData() {
    _data = null;
    notifyListeners();
  }

  bool get serverAvaliable => (_stream != null);

  void _closeConnect() {
    if (_channel != null) {
      _channel.sink.close();
      _channel = null;
    }

    if (_subScription != null) {
      _subScription.cancel();
      _subScription = null;
    }

    _stream = null;

    _data = null;
  }

  void _reConnect() {
    Future.delayed(
      Duration(milliseconds: reconectMilliseconds),
      () {
        if (_channel != null) return;
        _channel = IOWebSocketChannel.connect(urlServer);

        _listenWebSocket();
      },
    );
  }

  void sendMessage(message) {
    if (_channel != null) {
      _channel.sink.add(message);
    }
  }

  void close() {
    if (_channel != null) _channel.sink.close();

    super.dispose();
  }
}
