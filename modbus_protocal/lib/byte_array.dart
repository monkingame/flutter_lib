import 'dart:typed_data';

class ByteArray {
  Uint8List _data;

  ByteArray(List<int> data) {
    _data = Uint8List.fromList(data);
  }
}
