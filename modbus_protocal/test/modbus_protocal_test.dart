import 'package:modbus_protocal/byte_word.dart';

void main() {
  // test('adds one to input values', () {
  //   expect(calculator.addOne(0), 1);
  // });

  testByteWord();
}

void testByteWord() {
  final bw = ByteWord(1034);
  print(bw.origin);
  print(bw.word);
  print('${bw.high} , ${bw.low}');
}
