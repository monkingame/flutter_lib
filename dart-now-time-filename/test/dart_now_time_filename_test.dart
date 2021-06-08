// import 'package:dart_now_time_filename/dart_now_time_filename.dart';

import 'package:dart_now_time_filename/dart_now_time_filename.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NowFilename', () async {
    // 20210508-084919-305-149
    print(NowFilename.gen());

    await Future.delayed(Duration(milliseconds: 100));

    // header-20210508-084919-314-149
    print(NowFilename.gen(prefix: 'header-'));
    await Future.delayed(Duration(milliseconds: 100));

    // 20210508-084919-314-149.mp3
    print(NowFilename.gen(ext: '.mp3'));
    await Future.delayed(Duration(milliseconds: 100));

    // header-20210508-084919-314-149.mp3
    print(NowFilename.gen(prefix: 'header-', ext: '.mp3'));
    await Future.delayed(Duration(milliseconds: 100));

    // header-20210508@084919@314@149.mp3
    print(NowFilename.gen(prefix: 'header-', ext: '.mp3', seperator: '@'));
    await Future.delayed(Duration(milliseconds: 100));

    // 20210508084919314149.mp3
    print(NowFilename.gen(ext: '.mp3', seperator: null));
    await Future.delayed(Duration(milliseconds: 100));

    print(NowFilename.genSpecifyTime(time: DateTime(1999, 12, 3, 23, 12, 3)));
  });
}
