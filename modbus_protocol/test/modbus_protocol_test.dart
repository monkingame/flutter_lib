import 'dart:typed_data';

import 'package:byte_util/byte_word.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modbus_protocol/modbus_crc.dart';
import 'package:modbus_protocol/modbus_protocol.dart';

void main() {
  group('ModbusCRC.caculateCRC', () {
    test('known answer: read holding registers request', () {
      // 01 03 00 00 00 0A  ->  CRC 0xCDC5
      final bytes = Uint8List.fromList([0x01, 0x03, 0x00, 0x00, 0x00, 0x0A]);
      expect(ModbusCRC.caculateCRC(bytes), 0xCDC5);
    });

    test('known answer: read input registers request (slave 0x11)', () {
      // 11 03 00 6B 00 03  ->  CRC 0x8776
      final bytes = Uint8List.fromList([0x11, 0x03, 0x00, 0x6B, 0x00, 0x03]);
      expect(ModbusCRC.caculateCRC(bytes), 0x8776);
    });

    test('known answer: write single register request', () {
      // 01 06 00 01 00 03  ->  CRC 0x0B98
      final bytes = Uint8List.fromList([0x01, 0x06, 0x00, 0x01, 0x00, 0x03]);
      expect(ModbusCRC.caculateCRC(bytes), 0x0B98);
    });

    test('frame with CRC appended yields zero', () {
      // Valid RTU frame including CRC (low byte first): 01 03 00 00 00 0A C5 CD
      final frame =
          Uint8List.fromList([0x01, 0x03, 0x00, 0x00, 0x00, 0x0A, 0xC5, 0xCD]);
      expect(ModbusCRC.caculateCRC(frame), 0x0000);
    });

    test('empty input returns 0', () {
      expect(ModbusCRC.caculateCRC(Uint8List(0)), 0);
    });
  });

  group('ModbusProtocol', () {
    test('crc is exposed as ByteWord with little-endian bytes', () {
      final protocol =
          ModbusProtocol(Uint8List.fromList([0x01, 0x03, 0x00, 0x00, 0x00, 0x0A]));

      expect(protocol.crc, isA<ByteWord>());
      expect(protocol.crc.bytes, Uint8List.fromList([0xC5, 0xCD]));
      expect(protocol.crc.high.value, 0xCD);
      expect(protocol.crc.low.value, 0xC5);
    });
  });
}
