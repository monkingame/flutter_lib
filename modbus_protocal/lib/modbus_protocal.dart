library modbus_protocal;

import 'dart:typed_data';

import 'package:modbus_protocal/byte_word.dart';
import 'package:modbus_protocal/modbus_crc.dart';

class ModbusProtocol {
  final List<int> input;

  var _crc = ByteWord(0);

  ByteWord get crc => _crc;

  ModbusProtocol(this.input) : assert(input != null) {
    final bytes = Uint8List.fromList(input);
    int crc = ModbusCRC.caculateCRC(bytes);
    _crc = ByteWord(crc);
  }
}
