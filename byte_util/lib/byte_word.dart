import 'dart:typed_data';

import 'byte.dart';

class ByteWord {
  // final int value;

  // int _high = 0;
  // int _low = 0;

  // int get high => _high;
  // int get low => _low;

  // Uint8List get word => Uint8List.fromList([_high, _low]);

  // ByteWord(this.value) {
  //   _high = (value >> 8) & 0xFF;
  //   _low = value & 0xFF;
  // }

  Byte _high = Byte(0);
  Byte _low = Byte(0);

  Byte get high => _high;
  Byte get low => _low;

  ByteWord({required Byte high, required Byte low}) {
    _high = high;
    _low = low;
  }

  ByteWord.fromInt(int value) {
    _high = Byte(value >> 8);
    _low = Byte(value);
  }

  Uint8List get bytes => Uint8List.fromList([_high.value, _low.value]);

  @override
  String toString() {
    return _high.toString() + ',' + _low.toString();
  }
}
