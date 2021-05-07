import 'package:dart_now_time_filename/dart_now_time_filename.dart';

void main() {
  print(NowFilename.genNowFilename());
  print(NowFilename.genNowFilename(prefix: 'header-'));
  print(NowFilename.genNowFilename(ext: '.mp3'));
  print(NowFilename.genNowFilename(prefix: 'header-', ext: '.mp3'));
  print(NowFilename.genNowFilename(
      prefix: 'header-', ext: '.mp3', seperator: '@'));
  print(NowFilename.genNowFilename(prefix: null, ext: '.mp3', seperator: null));
}
