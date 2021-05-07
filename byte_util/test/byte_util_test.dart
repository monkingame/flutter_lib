import 'package:byte_util/byte_util.dart';

void main() {
  testFromReadable();
  testToReadable();
  testToBase64();
  testFromBase64();
  testClone();
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

void testToReadable() {}

void testToBase64() {}

void testFromBase64() {}

void testClone() {}
