import 'dart:typed_data';

import 'package:byte_util/byte_util.dart';
import 'package:flutter/material.dart';
import 'package:modbus_protocol/modbus_protocol.dart';

void main() {
  runApp(MyApp());
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('modbus example')),
      body: Center(
        child: ElevatedButton(
          child: Text('show Modbus crc'),
          onPressed: () {
            final bytes =
                Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 0xff, 0xa1, 0xdd]);
            final modbus = ModbusProtocol(bytes);
            final crc = modbus.crc;
            // 0x3D 0xAF
            print(ByteUtil.toReadable(crc.bytes));
          },
        ),
      ),
    );
  }
}
