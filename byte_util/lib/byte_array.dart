import 'dart:typed_data';

import 'package:byte_util/byte_util.dart';

/// byte array
class ByteArray {
  Uint8List _bytes = Uint8List(0);

  Uint8List get bytes => _bytes;

  ByteArray(Uint8List array) {
    _bytes = Uint8List.fromList(array);
  }

  ByteArray.fromByte(int value) {
    _bytes = _toArray(value);
  }

  ByteArray.combineArrays(Uint8List array1, Uint8List array2) {
    // _bytes = _combine(array1, array2);
    _bytes = ByteUtil.combine(array1, array2);
  }

  ByteArray.combine1(Uint8List array, int value) {
    // _bytes = _combine(array, _toArray(value));
    _bytes = ByteUtil.combine(array, _toArray(value));
  }

  ByteArray.combine2(int value, Uint8List array) {
    // _bytes = _combine(_toArray(value), array);
    _bytes = ByteUtil.combine(_toArray(value), array);
  }

  Uint8List append(int value) {
    // if (_bytes == null) {
    //   _bytes = _toArray(value);
    // } else {
    //   _bytes = _combine(_bytes, _toArray(value));
    // }
    // return _bytes;
    // return _combine(_bytes, _toArray(value));
    _bytes = ByteUtil.combine(_bytes, _toArray(value));
    return _bytes;
  }

  Uint8List appendArray(Uint8List array) {
    // if (_bytes == null) {
    //   _bytes = Uint8List.fromList(array);
    // } else {
    //   _bytes = _combine(_bytes, array);
    // }
    // return _bytes;

    // return _combine(_bytes, array);
    _bytes = ByteUtil.combine(_bytes, array);
    return _bytes;
  }

  Uint8List insert(int index, int value) {
    // if (index < 0) return _bytes;
    // // final actualIndex=index
    // if (_bytes.length == 0) {
    //   _bytes = Uint8List.fromList([value]);
    //   return _bytes;
    // }

    // final actIndex = index > _bytes.length ? _bytes.length : index;

    // // _bytes.insert(index, value);
    // // return _bytes;

    // var list = List<int>.from(_bytes);
    // list.insert(actIndex, value);
    // _bytes = Uint8List.fromList(list);
    // return _bytes;
    _bytes = ByteUtil.insert(_bytes, index, Uint8List.fromList([value]));
    return _bytes;
  }

  Uint8List insertArray(int index, Uint8List array) {
    _bytes = ByteUtil.insert(_bytes, index, array);
    return _bytes;
  }

  Uint8List remove(int index, int length) {
    _bytes = ByteUtil.remove(_bytes, index, length);
    return _bytes;
  }

  Uint8List _toArray(int value) {
    return Uint8List.fromList([value]);
  }

  // Uint8List _combine(Uint8List array1, Uint8List array2) {
  //   // if (array1 == null && array2 == null) return null;
  //   // if (array1 == null) return Uint8List.fromList(array2);
  //   // if (array2 == null) return Uint8List.fromList(array1);

  //   var list = Uint8List(array1.length + array2.length);

  //   for (int i = 0; i < array1.length; i++) {
  //     list[i] = array1[i];
  //   }
  //   for (int i = 0; i < array2.length; i++) {
  //     list[array1.length + i] = array2[i];
  //   }

  //   return Uint8List.fromList(list);
  // }
}
