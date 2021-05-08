# byte_util

dart byte utility


```
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


```
