// import 'package:flutter_test/flutter_test.dart';

import 'package:dart_now_time_filename/dart_now_time_filename.dart';

void main() {
  // test('adds one to input values', () {
  //   // final calculator = Calculator();
  //   // expect(calculator.addOne(0), 1);
  //   // expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  // });

  print(NowFilename.genNowFilename());
  print(NowFilename.genNowFilename(prefix: 'header-'));
  print(NowFilename.genNowFilename(ext: '.mp3'));
  print(NowFilename.genNowFilename(prefix: 'header-', ext: '.mp3'));
  print(NowFilename.genNowFilename(
      prefix: 'header-', ext: '.mp3', seperator: '@'));
  print(NowFilename.genNowFilename(prefix: null, ext: '.mp3', seperator: null));
}
