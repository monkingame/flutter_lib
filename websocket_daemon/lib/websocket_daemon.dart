library websocket_daemon;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

/// web socket daemon model
class ModelDaemonWebSocket extends ChangeNotifier {
  IOWebSocketChannel? _channel;
  Stream? _stream;
  StreamSubscription? _subScription;

  /// reconnect interval: milliseconds
  final int reconectMilliseconds;

  /// server url
  final String urlServer;

  /// data receiverd
  dynamic _data;

  /// constrcutor
  ModelDaemonWebSocket({
    required this.urlServer,
    this.reconectMilliseconds = 1000,
  });

  /// connect to server
  void initConnection() {
    _channel = IOWebSocketChannel.connect(urlServer);

    _listenWebSocket();
  }

  _listenWebSocket() {
    _stream = _channel?.stream.asBroadcastStream();

    _subScription = _stream?.listen(
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

  /// data received
  dynamic get data => _data;

  /// drop data if needed
  void dropData() {
    _data = null;
    notifyListeners();
  }

  /// if server is avaliable
  bool get serverAvaliable => (_stream != null);

  void _closeConnect() {
    if (_channel != null) {
      _channel?.sink.close();
      _channel = null;
    }

    if (_subScription != null) {
      _subScription?.cancel();
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

  /// send message to server
  void sendMessage(message) {
    if (_channel != null) {
      _channel?.sink.add(message);
    }
  }

  /// close connection
  void close() {
    if (_channel != null) _channel?.sink.close();

    super.dispose();
  }
}
