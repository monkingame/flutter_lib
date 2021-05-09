# modbus_protocol

Modbus is a data communications protocol originally published by Modicon (now Schneider Electric) in 1979 for use with its programmable logic controllers (PLCs). 

Modbus has become a de facto standard communication protocol and is now a commonly available means of connecting industrial electronic devices.  


***

Usage:
```
void testModbusProtocol() {
  final bytes = [1, 2, 3, 4, 5, 6, 7, 0xff, 0xa1, 0xdd];
  final modbus = ModbusProtocol(bytes);
  final crc = modbus.crc;
  // got:[175, 61]
  print(crc.word);
}

```

***

Reference:

[MODBUS Protocol Specification](https://modbus.org/docs/Modbus_Application_Protocol_V1_1b3.pdf)

[C language Modbus CRC16 ](https://www.modbustools.com/modbus_crc16.htm)

[Wiki Modbus](https://en.wikipedia.org/wiki/Modbus)

