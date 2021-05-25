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
    _bytes = ByteUtil.combine(arrayFirst: array1, arraySecond: array2);
  }

  ByteArray.combine1(Uint8List array, int value) {
    _bytes = ByteUtil.combine(arrayFirst: array, arraySecond: _toArray(value));
  }

  ByteArray.combine2(int value, Uint8List array) {
    _bytes = ByteUtil.combine(arrayFirst: _toArray(value), arraySecond: array);
  }

  Uint8List append(int value) {
    _bytes = ByteUtil.combine(arrayFirst: _bytes, arraySecond: _toArray(value));
    return _bytes;
  }

  Uint8List appendArray(Uint8List array) {
    _bytes = ByteUtil.combine(arrayFirst: _bytes, arraySecond: array);
    return _bytes;
  }

  Uint8List insert({required int indexStart, required int value}) {
    _bytes = ByteUtil.insert(
        origin: _bytes,
        indexStart: indexStart,
        arrayInsert: Uint8List.fromList([value]));
    return _bytes;
  }

  Uint8List insertArray(
      {required int indexStart, required Uint8List arrayInsert}) {
    _bytes = ByteUtil.insert(
        origin: _bytes, indexStart: indexStart, arrayInsert: arrayInsert);
    return _bytes;
  }

  Uint8List remove({required int indexStart, required int lengthRemove}) {
    _bytes = ByteUtil.remove(
        origin: _bytes, indexStart: indexStart, lengthRemove: lengthRemove);
    return _bytes;
  }

  // Uint8List _toArray(int value) {
  //   return Uint8List.fromList([value]);
  // }
  Uint8List _toArray(int value) => Uint8List.fromList([value]);
}
