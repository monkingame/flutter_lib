import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websocket_daemon/websocket_daemon.dart';

void main() {
  HttpOverrides.global = SelfSignedCertHttpOverrides();

  final url = 'wss://127.0.0.1:8000/test';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ModelDaemonWebSocket(urlServer: url),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    final wsModel = Provider.of<ModelDaemonWebSocket>(context, listen: false);
    wsModel.initConnection();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('websocket daemon model example')),
      body: Container(
        child: _buildDataPlaceHolder(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.home),
      ),
    );
  }

  Widget _buildDataPlaceHolder() {
    return Consumer<ModelDaemonWebSocket>(
      builder: (context, modelWebSocket, child) {
        final data = modelWebSocket.data;
        return Container(
          child: Text(data.toString()),
        );
      },
    );
  }
}

class SelfSignedCertHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
