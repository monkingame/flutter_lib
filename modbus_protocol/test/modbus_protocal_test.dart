// use: byte_util: ^1.1.0
import 'package:byte_util/byte_util.dart';
import 'package:modbus_protocol/modbus_protocol.dart';

void main() {
  testModbusProtocol();
}

void testModbusProtocol() {
  final bytes = [1, 2, 3, 4, 5, 6, 7, 0xff, 0xa1, 0xdd];
  final modbus = ModbusProtocol(bytes);
  final crc = modbus.crc;
  // 0xAF 0x3D
  print(ByteUtil.toReadable(crc.word));
}
