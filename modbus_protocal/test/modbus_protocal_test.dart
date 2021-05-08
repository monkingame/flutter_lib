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
  print(bw.origin);
  print(bw.word);
  print('${bw.high} , ${bw.low}');
}

void testByteArray() {
  final array1 = ByteArray([1, 2, 3]);
  print(array1.bytes);

  final array2 = ByteArray.fromByte(3);
  print(array2.bytes);
}
