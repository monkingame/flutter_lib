import 'dart:typed_data';
import 'package:byte_util/byte.dart';
import 'package:byte_util/byte_array.dart';
import 'package:byte_util/byte_double_word.dart';
import 'package:byte_util/byte_util.dart';
import 'package:byte_util/byte_word.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'byte util example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('byte util example')),
      body: Center(child: WidgetExample()),
    );
  }
}

class WidgetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: testFromReadable, child: Text('FromReadable')),
              ElevatedButton(
                  onPressed: testToReadable, child: Text('ToReadable')),
              ElevatedButton(onPressed: testToBase64, child: Text('ToBase64')),
              ElevatedButton(
                  onPressed: testFromBase64, child: Text('FromBase64')),
              ElevatedButton(onPressed: testClone, child: Text('Clone')),
              ElevatedButton(onPressed: testSame, child: Text('Same')),
              ElevatedButton(onPressed: testExtract, child: Text('Extract')),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: testByteArrayContructor,
                  child: Text('ByteArrayContructor')),
              ElevatedButton(
                  onPressed: testByteClass, child: Text('ByteClass')),
            ],
          ),
        ),
      ],
    );
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
    final bytes =
        Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 20, 77]);
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

  void testSame() {
    final bytes1 = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);
    final bytes2 = Uint8List.fromList([0xA1, 30, 10, 32]);
    final same = ByteUtil.same(bytes1, bytes2);
    // false
    print(same);
  }

  void testExtract() {
    final bytes = Uint8List.fromList([0x80, 01, 02, 0xff, 0xA1, 30, 10, 32]);

    // 0x1 0x2 0xFF
    print(ByteUtil.toReadable(ByteUtil.extract(bytes, 1, 3)));

    // null
    print(ByteUtil.toReadable(ByteUtil.extract(bytes, 0, 0)));

    // 0x80 0x1 0x2 0xFF 0xA1 0x1E 0xA 0x20
    print(ByteUtil.toReadable(ByteUtil.extract(bytes, 0, 100)));

    // null
    print(ByteUtil.toReadable(ByteUtil.extract(bytes, 10, 8)));

    // 0x80 0x1 0x2 0xFF 0xA1 0x1E 0xA 0x20
    print(ByteUtil.toReadable(ByteUtil.extract(bytes, 0, 8)));

    // null
    print(ByteUtil.toReadable(ByteUtil.extract(bytes, 8, 1)));

    // 0x20
    print(ByteUtil.toReadable(ByteUtil.extract(bytes, 7, 1)));
  }

  void testByteArrayContructor() {
    final arr1 = ByteArray(Uint8List.fromList([1, 2, 3]));
    print(arr1.bytes);

    final arr2 = ByteArray.fromByte(3);
    print(arr2.bytes);

    final arr3 = ByteArray.combineArrays(
        Uint8List.fromList([1, 2, 3]), Uint8List.fromList([4, 5, 6]));
    print(arr3.bytes);

    final arr4 = ByteArray.combine1(Uint8List.fromList([1, 2, 3]), 7);
    print(arr4.bytes);

    final arr5 = ByteArray.combine2(8, Uint8List.fromList([1, 2, 3]));
    print(arr5.bytes);

    arr5.append(10);
    print(arr5.bytes);

    arr5.appendArray(Uint8List.fromList([9, 9]));
    print(arr5.bytes);

    arr5.insert(1, 12);
    print(arr5.bytes);

    arr5.insert(100, 13);
    print(arr5.bytes);

    arr5.insertArray(3, Uint8List.fromList([23, 23]));
    print(arr5.bytes);

    arr5.remove(0, 1);
    print(arr5.bytes);

    arr5.remove(3, 9);
    print(arr5.bytes);
  }

  void testByteClass() {
    final byte1 = Byte(3);
    final byte2 = Byte(0xA1);
    final byte3 = Byte(12);
    final byte4 = Byte(65);
    print(byte1);

    final word = ByteWord(high: byte2, low: byte1);
    print(word);

    final doubleWord =
        ByteDoubleWord(one: byte1, two: byte2, three: byte3, four: byte4);
    print(doubleWord);
  }
}
