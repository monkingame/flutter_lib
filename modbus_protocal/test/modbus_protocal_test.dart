import 'package:byte_util/byte_util.dart';

import '../lib/modbus_protocal.dart';

void main() {
  // test('adds one to input values', () {
  //   expect(calculator.addOne(0), 1);
  // });
  testModbusProtocol();
}

void testModbusProtocol() {
  final bytes = [1, 2, 3, 4, 5, 6, 7, 0xff, 0xa1, 0xdd];
  final modbus = ModbusProtocol(bytes);
  final crc = modbus.crc;
  // print(ByteUtil.toReadable(crc.word));
}
