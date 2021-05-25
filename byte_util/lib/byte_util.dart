library byte_util;

import 'dart:convert';
import 'dart:typed_data';

/// Radix: hex&dec
enum Radix {
  hex,
  dec,
}

/// provide bytes util
abstract class ByteUtil {
  ByteUtil._();

  /// covnert readable string to bytes array.
  /// byte splitted by space or comma,
  /// e.g. '0xaa ff 01 02 ,03 ,00 A0'
  /// default radix is hex,or specified radix
  static Uint8List? fromReadable(String? readable, {Radix radix = Radix.hex}) {
    if (readable == null || readable.isEmpty) return null;

    final List<int> list = [];
    final split = RegExp(' +');
    final strArray = readable.replaceAll(',', ' ').split(split);

    for (String str in strArray) {
      var pure = str.trim();
      if (radix == Radix.hex && pure.startsWith('0x')) {
        pure = pure.substring(2);
      }

      final value = int.tryParse(pure, radix: radix == Radix.hex ? 16 : 10);
      if (value == null) return null;

      list.add(value);
    }

    if (list.length <= 0) return null;

    return Uint8List.fromList(list);
  }

  /// convert byytes array to readable string.
  /// default radix is hex ,or specified radix
  static String toReadable(Uint8List? buffer, {Radix radix = Radix.hex}) {
    if (buffer == null || buffer.length <= 0) return '';

    final List<String> list = [];
    for (int data in buffer) {
      var str =
          data.toRadixString(radix == Radix.hex ? 16 : 10).padLeft(2, '0');
      if (radix == Radix.hex) str = ('0x' + str.toUpperCase());
      list.add(str);
    }
    final result = list.join(' ');
    return result;
  }

  /// convert bytes array to base64 string
  static String toBase64(Uint8List buffer) {
    final str = base64Encode(buffer);
    return str;
  }

  /// convert base64 string to bytes array
  static Uint8List fromBase64(String base64) {
    final data = base64Decode(base64);
    return data;
  }

  /// clone bytes array
  static Uint8List clone(Uint8List origin) {
    return Uint8List.fromList(origin);
  }

  static bool same(Uint8List bytes1, Uint8List bytes2) {
    if (bytes1.length != bytes2.length) return false;

    for (int i = 0; i < bytes1.length; i++) {
      if (bytes1[i] != bytes2[i]) return false;
    }

    return true;
  }

  static Uint8List? extract(
      {required Uint8List origin,
      required int indexStart,
      required int length}) {
    if (indexStart >= origin.length) return null;

    int end = indexStart + length;
    if (end >= origin.length) {
      end = origin.length;
    }

    final sub = origin.sublist(indexStart, end);
    return sub;
  }

  static Uint8List combine(
      {required Uint8List arrayFirst, required Uint8List arraySecond}) {
    return insert(
        origin: arrayFirst,
        indexStart: arrayFirst.length,
        arrayInsert: arraySecond);
  }

  static Uint8List insert(
      {required Uint8List origin,
      required int indexStart,
      required Uint8List arrayInsert}) {
    if (indexStart < 0 || arrayInsert.length <= 0) return origin;

    if (origin.length == 0) {
      return Uint8List.fromList(arrayInsert);
    }

    final actIndex = indexStart > origin.length ? origin.length : indexStart;

    var list = List<int>.from(origin);
    list.insertAll(actIndex, arrayInsert);
    return Uint8List.fromList(list);
  }

  static Uint8List remove(
      {required Uint8List origin,
      required int indexStart,
      required int lengthRemove}) {
    if (indexStart < 0 || lengthRemove <= 0) return origin;
    if (origin.length == 0) return origin;
    if (indexStart >= origin.length) return origin;

    final actEnd = (indexStart + lengthRemove > origin.length)
        ? origin.length
        : (indexStart + lengthRemove);
    var list = List<int>.from(origin);
    list.removeRange(indexStart, actEnd);
    return Uint8List.fromList(list);
  }
}
