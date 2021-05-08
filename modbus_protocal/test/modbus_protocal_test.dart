import 'dart:typed_data';

import 'package:modbus_protocal/byte_array.dart';
import 'package:modbus_protocal/byte_word.dart';

void main() {
  // test('adds one to input values', () {
  //   expect(calculator.addOne(0), 1);
  // });

  // testByteWord();
  testByteArray();
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
