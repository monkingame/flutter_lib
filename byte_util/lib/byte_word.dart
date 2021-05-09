import 'dart:typed_data';

class ByteWord {
  final int value;

  int _high = 0;
  int _low = 0;

  int get high => _high;
  int get low => _low;

  Uint8List get word => Uint8List.fromList([_high, _low]);

  ByteWord(this.value) {
    _high = (value >> 8) & 0xFF;
    _low = value & 0xFF;
  }
}
