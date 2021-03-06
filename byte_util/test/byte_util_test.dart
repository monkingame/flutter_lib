// import 'dart:typed_data';
// import 'package:byte_util/byte_util.dart';

void main() {
  // testFromReadable();
  // testToReadable();
  // testToBase64();
  // testFromBase64();
  // testClone();
  // testSame();
  // testExtract();
}

// void testFromReadable() {
//   const str1 = '01 02, ff 0x10,0xfa , 90 76 AF a0';
//   final bytes1 = ByteUtil.fromReadable(str1);
//   // [1, 2, 255, 16, 250, 144, 118, 175, 160]
//   print(bytes1);

//   const str2 = '101 02 90 01,33 90 76 102, 901';
//   final bytes2 = ByteUtil.fromReadable(str2, radix: Radix.dec);
//   // [101, 2, 90, 1, 33, 90, 76, 102, 133]
//   print(bytes2);
// }

// void testToReadable() {
//   final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 20, 77]);
//   final str1 = ByteUtil.toReadable(bytes);
//   // 0x80 0x1 0x2 0xFF 0xA1 0x1E 0xA 0x14 0x4D
//   print(str1);
//   final str2 = ByteUtil.toReadable(bytes, radix: Radix.dec);
//   // 128 1 2 255 161 30 10 20 77
//   print(str2);
// }

// void testToBase64() {
//   final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);
//   final base64 = ByteUtil.toBase64(bytes);
//   // gAEC/6EeCiA=
//   print(base64);
// }

// void testFromBase64() {
//   final base64 = 'gAEC/6EeCiA=';
//   final bytes = ByteUtil.fromBase64(base64);
//   // [128, 1, 2, 255, 161, 30, 10, 32]
//   print(bytes);
// }

// void testClone() {
//   final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);
//   final clone = ByteUtil.clone(bytes);
//   // [128, 1, 2, 255, 161, 30, 10, 32]
//   print(clone);
// }

// void testSame() {
//   final bytes1 = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);
//   final bytes2 = Uint8List.fromList([0xA1, 30, 10, 32]);
//   final same = ByteUtil.same(bytes1, bytes2);
//   // true
//   print(same);
// }

// void testExtract() {
//   final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);

//   // 0x1 0x2 0xFF
//   print(ByteUtil.toReadable(ByteUtil.extract(bytes, 1, 3)));

//   // null
//   print(ByteUtil.toReadable(ByteUtil.extract(bytes, 0, 0)));

//   // 0x80 0x1 0x2 0xFF 0xA1 0x1E 0xA 0x20
//   print(ByteUtil.toReadable(ByteUtil.extract(bytes, 0, 100)));

//   // null
//   print(ByteUtil.toReadable(ByteUtil.extract(bytes, 10, 8)));

//   // 0x80 0x1 0x2 0xFF 0xA1 0x1E 0xA 0x20
//   print(ByteUtil.toReadable(ByteUtil.extract(bytes, 0, 8)));

//   // null
//   print(ByteUtil.toReadable(ByteUtil.extract(bytes, 8, 1)));

//   // 0x20
//   print(ByteUtil.toReadable(ByteUtil.extract(bytes, 7, 1)));
// }
