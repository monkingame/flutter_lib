import 'dart:typed_data';

import 'package:byte_util/byte_array.dart';
import 'package:byte_util/byte_util.dart';
import 'package:byte_util/byte_word.dart';

void main() {
  testFromReadable();
  testToReadable();
  testToBase64();
  testFromBase64();
  testClone();
  testByteWord();
  testByteArray();
}

void testFromReadable() {
  const str1 = '01 02, ff 0x10,0xfa , 90 76 AF a0';
  final bytes1 = ByteUtil.fromReadable(str1);
  // [1, 2, 255, 16, 250, 144, 118, 175, 160]
  print(bytes1);

  const str2 = '101 02 90 01,33 90 76 102, 901';
  final bytes2 = ByteUtil.fromReadable(str2, radix: Radix.dec);
  // [101, 2, 90, 1, 33, 90, 76, 102, 133]
  print(bytes2);
}

void testToReadable() {
  final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 20, 77]);
  final str1 = ByteUtil.toReadable(bytes);
  // 0x80 0x1 0x2 0xFF 0xA1 0x1E 0xA 0x14 0x4D
  print(str1);
  final str2 = ByteUtil.toReadable(bytes, radix: Radix.dec);
  // 128 1 2 255 161 30 10 20 77
  print(str2);
}

void testToBase64() {
  final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);
  final base64 = ByteUtil.toBase64(bytes);
  // gAEC/6EeCiA=
  print(base64);
}

void testFromBase64() {
  final base64 = 'gAEC/6EeCiA=';
  final bytes = ByteUtil.fromBase64(base64);
  // [128, 1, 2, 255, 161, 30, 10, 32]
  print(bytes);
}

void testClone() {
  final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);
  final clone = ByteUtil.clone(bytes);
  // [128, 1, 2, 255, 161, 30, 10, 32]
  print(clone);
}

void testByteWord() {
  final bw = ByteWord(1034);
  print(bw.value);
  print(bw.word);
  print('${bw.high} , ${bw.low}');
}

void testByteArray() {
  final array1 = ByteArray([1, 2, 3]);
  print(array1.bytes);

  final array2 = ByteArray.fromByte(3);
  print(array2.bytes);

  // final bytes = Uint8List.fromList([3, 2, 1]);
  final array3 = ByteArray(Uint8List.fromList([3, 2, 1]));
  print(array3.bytes);

  final array4 = ByteArray.combineArrays([1, 2, 3], [0xf0, 0xf2, 0xff]);
  print(array4.bytes);

  final array5 = ByteArray.combine1([1, 2, 3], 0xff);
  print(array5.bytes);

  final array6 = ByteArray.combine2(0xff, [1, 2, 3]);
  print(array6.bytes);

  array6.append(123);
  print(array6.bytes);

  array6.appendArray([33, 22, 11]);
  print(array6.bytes);
}
