// import 'package:dart_now_time_filename/dart_now_time_filename.dart';

import 'package:dart_now_time_filename/dart_now_time_filename.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NowFilename', () async {
    // 20210508-084919-305-149
    print(NowFilename.gen());

    // header-20210508-084919-314-149
    print(NowFilename.gen(prefix: 'header-'));

    // 20210508-084919-314-149.mp3
    print(NowFilename.gen(ext: '.mp3'));

    // header-20210508-084919-314-149.mp3
    print(NowFilename.gen(prefix: 'header-', ext: '.mp3'));

    // header-20210508@084919@314@149.mp3
    print(NowFilename.gen(prefix: 'header-', ext: '.mp3', seperator: '@'));

    // 20210508084919314149.mp3
    print(NowFilename.gen(ext: '.mp3', seperator: null));

    print(NowFilename.genSpecifyTime(time: DateTime(1999, 12, 3, 23, 12, 3)));
  });
}
