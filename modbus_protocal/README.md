# modbus_protocal

```
void testModbusProtocol() {
  final bytes = [1, 2, 3, 4, 5, 6, 7, 0xff, 0xa1, 0xdd];
  final modbus = ModbusProtocol(bytes);
  final crc = modbus.crc;
  // got:[175, 61]
  print(crc.word);
}

```
