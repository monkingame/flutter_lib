class Byte {
  int _byte = 0;

  int get value => _byte;

  Byte(int value) {
    _byte = value & 0xFF;
  }
}
