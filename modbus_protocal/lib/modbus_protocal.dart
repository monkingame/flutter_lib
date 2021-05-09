library modbus_protocal;

import 'dart:typed_data';
import 'package:byte_util/byte_word.dart';
import 'package:modbus_protocal/modbus_crc.dart';

/// modbus protocol
class ModbusProtocol {
  /// origin input bytes array
  final List<int> input;

  var _crc = ByteWord(0);

  /// modbus CRC data
  ByteWord get crc => _crc;

  /// input bytes array
  ModbusProtocol(this.input) {
    final bytes = Uint8List.fromList(input);
    // print(bytes.length);

    int crc = ModbusCRC.caculateCRC(bytes);
    _crc = ByteWord(crc);
  }
}
