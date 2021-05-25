import 'dart:typed_data';

import 'package:byte_util/byte_util.dart';

import 'byte.dart';

/// byte array
class ByteArray {
  Uint8List _bytes = Uint8List(0);

  /// bytes in UInt8List
  Uint8List get bytes => _bytes;

  /// bytes in List<Byte>
  List<Byte> get array => _bytes.map((byte) => Byte(byte)).toList();

  ByteArray(Uint8List array) {
    _bytes = Uint8List.fromList(array);
  }

  ByteArray.fromByte(int value) {
    _bytes = _toArray(value);
  }

  ByteArray.combineArrays(Uint8List array1, Uint8List array2) {
    _bytes = ByteUtil.combine(array1, array2);
  }

  ByteArray.combine1(Uint8List array, int value) {
    _bytes = ByteUtil.combine(array, _toArray(value));
  }

  ByteArray.combine2(int value, Uint8List array) {
    _bytes = ByteUtil.combine(_toArray(value), array);
  }

  Uint8List append(int value) {
    _bytes = ByteUtil.combine(_bytes, _toArray(value));
    return _bytes;
  }

  Uint8List appendArray(Uint8List array) {
    _bytes = ByteUtil.combine(_bytes, array);
    return _bytes;
  }

  Uint8List insert(int index, int value) {
    _bytes = ByteUtil.insert(
        origin: _bytes,
        indexStart: index,
        subToInsert: Uint8List.fromList([value]));
    return _bytes;
  }

  Uint8List insertArray(int index, Uint8List array) {
    _bytes =
        ByteUtil.insert(origin: _bytes, indexStart: index, subToInsert: array);
    return _bytes;
  }

  Uint8List remove(int index, int length) {
    _bytes = ByteUtil.remove(
        origin: _bytes, indexStart: index, lengthRemove: length);
    return _bytes;
  }

  Uint8List _toArray(int value) {
    return Uint8List.fromList([value]);
  }
}
