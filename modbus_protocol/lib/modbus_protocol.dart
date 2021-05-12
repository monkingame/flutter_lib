library modbus_protocol;

import 'dart:typed_data';
import 'package:byte_util/byte_word.dart';

import 'modbus_crc.dart';

/// modbus protocol
class ModbusProtocol {
  /// origin input bytes array
  final Uint8List input;

  var _crc = ByteWord.fromInt(0);

  /// modbus CRC data
  ByteWord get crc => _crc;

  /// input bytes array
  ModbusProtocol(this.input) {
    final bytes = input;
    // print(bytes.length);

    int crc = ModbusCRC.caculateCRC(bytes);
    _crc = ByteWord.fromInt(crc);
  }
}
