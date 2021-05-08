library modbus_protocal;

import 'package:modbus_protocal/byte_word.dart';

class ModbusProtocol {
  final List<int> bytes;

  var _crc = ByteWord(0);

  ModbusProtocol(this.bytes) {}
}
