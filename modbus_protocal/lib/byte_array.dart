import 'dart:typed_data';

class ByteArray {
  Uint8List _bytes;

  Uint8List get bytes => _bytes;

  ByteArray(List<int> array) {
    _bytes = Uint8List.fromList(array);
  }

  ByteArray.fromByte(int value) {
    _bytes = _toArray(value);
  }

  ByteArray.combineArrays(List<int> array1, List<int> array2) {
    _bytes = _combine(array1, array2);
  }

  ByteArray.combine1(List<int> array, int value) {
    _bytes = _combine(array, _toArray(value));
  }

  ByteArray.combine2(int value, List<int> array) {
    _bytes = _combine(_toArray(value), array);
  }

  Uint8List _toArray(int value) {
    return Uint8List.fromList([value]);
  }

  Uint8List _combine(List<int> array1, List<int> array2) {
    if (array1 == null && array2 == null) return null;
    if (array1 == null) return Uint8List.fromList(array2);
    if (array2 == null) return Uint8List.fromList(array1);

    var list = List<int>.filled(array1.length + array2.length, 0);

    for (int i = 0; i < array1.length; i++) {
      list[i] = array1[i];
    }
    for (int i = 0; i < array2.length; i++) {
      list[array1.length + i] = array2[i];
    }

    return Uint8List.fromList(list);
  }
}
