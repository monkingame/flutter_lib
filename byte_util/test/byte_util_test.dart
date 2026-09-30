import 'dart:typed_data';

import 'package:byte_util/byte.dart';
import 'package:byte_util/byte_array.dart';
import 'package:byte_util/byte_double_word.dart';
import 'package:byte_util/byte_util.dart';
import 'package:byte_util/byte_word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ByteUtil.fromReadable', () {
    test('hex readable string with comma, space and 0x prefix', () {
      const str1 = '01 02, ff 0x10,0xfa , 90 76 AF a0';
      final bytes1 = ByteUtil.fromReadable(str1);
      expect(bytes1, Uint8List.fromList([1, 2, 255, 16, 250, 144, 118, 175, 160]));
    });

    test('dec readable string', () {
      const str2 = '101 02 90 01,33 90 76 102, 901';
      final bytes2 = ByteUtil.fromReadable(str2, radix: Radix.dec);
      expect(bytes2, Uint8List.fromList([101, 2, 90, 1, 33, 90, 76, 102, 133]));
    });

    test('null/empty returns null', () {
      expect(ByteUtil.fromReadable(null), isNull);
      expect(ByteUtil.fromReadable(''), isNull);
    });

    test('invalid token returns null', () {
      expect(ByteUtil.fromReadable('0xzz'), isNull);
    });
  });

  group('ByteUtil.toReadable', () {
    test('hex default', () {
      final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 20, 77]);
      expect(ByteUtil.toReadable(bytes), '0x80 0x01 0x02 0xFF 0xA1 0x1E 0x0A 0x14 0x4D');
    });

    test('dec', () {
      final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1]);
      expect(ByteUtil.toReadable(bytes, radix: Radix.dec), '128 01 02 255 161');
    });

    test('null/empty returns empty string', () {
      expect(ByteUtil.toReadable(null), '');
      expect(ByteUtil.toReadable(Uint8List(0)), '');
    });
  });

  group('ByteUtil.base64', () {
    test('toBase64 then fromBase64 round trip', () {
      final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);
      final base64 = ByteUtil.toBase64(bytes);
      expect(base64, 'gAEC/6EeCiA=');
      final back = ByteUtil.fromBase64(base64);
      expect(ByteUtil.same(back, bytes), isTrue);
    });
  });

  group('ByteUtil.array helpers', () {
    test('clone makes an equal copy', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final clone = ByteUtil.clone(bytes);
      expect(clone, isNot(same(bytes)));
      expect(ByteUtil.same(clone, bytes), isTrue);
    });

    test('same compares element wise', () {
      final bytes1 = Uint8List.fromList([0x80, 01, 02, 0xff]);
      final bytes2 = Uint8List.fromList([0x80, 01, 02, 0xff]);
      final bytes3 = Uint8List.fromList([0xA1, 30, 10, 32]);
      expect(ByteUtil.same(bytes1, bytes2), isTrue);
      expect(ByteUtil.same(bytes1, bytes3), isFalse);
      expect(ByteUtil.same(bytes1, Uint8List.fromList([0x80, 01])), isFalse);
    });

    test('extract with in-range/short/out-of-range length', () {
      final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);
      expect(ByteUtil.extract(origin: bytes, indexStart: 1, length: 3),
          Uint8List.fromList([01, 02, 0xff]));
      expect(ByteUtil.extract(origin: bytes, indexStart: 0, length: 100), bytes);
      expect(ByteUtil.extract(origin: bytes, indexStart: 7, length: 1),
          Uint8List.fromList([32]));
      expect(ByteUtil.extract(origin: bytes, indexStart: 8, length: 1), isNull);
      expect(ByteUtil.extract(origin: bytes, indexStart: 10, length: 8), isNull);
    });

    test('combine and insert', () {
      final combined = ByteUtil.combine(
          arrayFirst: Uint8List.fromList([1, 2, 3]),
          arraySecond: Uint8List.fromList([4, 5, 6]));
      expect(combined, Uint8List.fromList([1, 2, 3, 4, 5, 6]));

      final inserted = ByteUtil.insert(
          origin: Uint8List.fromList([1, 3]),
          indexStart: 1,
          arrayInsert: Uint8List.fromList([2]));
      expect(inserted, Uint8List.fromList([1, 2, 3]));

      // insert beyond length appends at end
      final appended = ByteUtil.insert(
          origin: Uint8List.fromList([1]),
          indexStart: 100,
          arrayInsert: Uint8List.fromList([2]));
      expect(appended, Uint8List.fromList([1, 2]));
    });

    test('remove', () {
      final removed = ByteUtil.remove(
          origin: Uint8List.fromList([1, 2, 3, 4, 5]),
          indexStart: 1,
          lengthRemove: 2);
      expect(removed, Uint8List.fromList([1, 4, 5]));

      // length longer than remaining
      final removedShort = ByteUtil.remove(
          origin: Uint8List.fromList([1, 2, 3]),
          indexStart: 1,
          lengthRemove: 10);
      expect(removedShort, Uint8List.fromList([1]));
    });
  });

  group('Byte', () {
    test('value is masked to 0xFF', () {
      expect(Byte(0x1FF).value, 0xFF);
      expect(Byte(-1).value, 0xFF);
    });

    test('toString is 0x-prefixed uppercase hex', () {
      expect(Byte(3).toString(), '0x03');
      expect(Byte(0xA1).toString(), '0xA1');
    });
  });

  group('ByteWord', () {
    test('fromInt little endian bytes', () {
      final word = ByteWord.fromInt(0x0A03);
      expect(word.bytes, Uint8List.fromList([0x03, 0x0A]));
      expect(word.high.value, 0x0A);
      expect(word.low.value, 0x03);
    });

    test('custom high/low', () {
      final word = ByteWord(high: Byte(0xA1), low: Byte(0x03));
      expect(word.toString(), '0xA1,0x03');
      expect(word.bytes, Uint8List.fromList([0x03, 0xA1]));
    });
  });

  group('ByteDoubleWord', () {
    test('fromInt builds four bytes little endian', () {
      final dw = ByteDoubleWord.fromInt(0x0AFD7BC3);
      expect(dw.bytes, Uint8List.fromList([0xC3, 0x7B, 0xFD, 0x0A]));
      expect(dw.toString(), '0x0A,0xFD,0x7B,0xC3');
    });

    test('custom bytes order in toString is four,three,two,one', () {
      final dw = ByteDoubleWord(
          one: Byte(1), two: Byte(2), three: Byte(3), four: Byte(4));
      expect(dw.toString(), '0x04,0x03,0x02,0x01');
    });
  });

  group('ByteArray', () {
    test('constructors and helpers', () {
      final arr1 = ByteArray(Uint8List.fromList([1, 2, 3]));
      expect(arr1.bytes, Uint8List.fromList([1, 2, 3]));
      expect(arr1.array.length, 3);

      final arr2 = ByteArray.fromByte(3);
      expect(arr2.bytes, Uint8List.fromList([3]));

      final arr3 = ByteArray.combineArrays(
          Uint8List.fromList([1, 2, 3]), Uint8List.fromList([4, 5, 6]));
      expect(arr3.bytes, Uint8List.fromList([1, 2, 3, 4, 5, 6]));

      final arr4 = ByteArray.combine1(Uint8List.fromList([1, 2, 3]), 7);
      expect(arr4.bytes, Uint8List.fromList([1, 2, 3, 7]));

      final arr5 = ByteArray.combine2(8, Uint8List.fromList([1, 2, 3]));
      expect(arr5.bytes, Uint8List.fromList([8, 1, 2, 3]));
      expect(arr5.append(10), Uint8List.fromList([8, 1, 2, 3, 10]));
      expect(arr5.appendArray(Uint8List.fromList([9, 9])),
          Uint8List.fromList([8, 1, 2, 3, 10, 9, 9]));
      expect(arr5.insert(indexStart: 1, value: 12),
          Uint8List.fromList([8, 12, 1, 2, 3, 10, 9, 9]));
      expect(arr5.insertArray(indexStart: 3, arrayInsert: Uint8List.fromList([23, 23])),
          Uint8List.fromList([8, 12, 1, 23, 23, 2, 3, 10, 9, 9]));
      expect(arr5.remove(indexStart: 0, lengthRemove: 1),
          Uint8List.fromList([12, 1, 23, 23, 2, 3, 10, 9, 9]));
    });
  });
}
