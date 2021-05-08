class ByteWord {
  final int value;

  int _high;
  int _low;

  int get high => _high;
  int get low => _low;

  List<int> get word => [_high, _low];

  ByteWord(this.value) {
    _high = (value >> 8) & 0xFF;
    _low = value & 0xFF;
  }
}
