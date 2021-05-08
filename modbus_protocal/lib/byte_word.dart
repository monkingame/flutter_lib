class ByteWord {
  final int origin;

  int _high;
  int _low;

  int get high => _high;
  int get low => _low;

  List<int> get word => [_high, _low];

  ByteWord(this.origin) {
    _high = (origin >> 8) & 0xFF;
    _low = origin & 0xFF;
  }
}
