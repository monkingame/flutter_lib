import 'dart:typed_data';

class ByteArray {
  Uint8List _bytes;

  Uint8List get bytes => _bytes;

  ByteArray(List<int> list) {
    _bytes = Uint8List.fromList(list);
  }

  ByteArray.fromByte(int value) {
    _bytes = _toArray(value);
  }

  Uint8List _toArray(int value) {
    return Uint8List.fromList([value]);
  }
}
