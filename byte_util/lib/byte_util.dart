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
      var str = data.toRadixString(radix == Radix.hex ? 16 : 10);
      if (radix == Radix.hex) str = ('0x' + str.toUpperCase());
      list.add(str);
    }
    final result = list.join(' ');
    return result;
  }

  /// convert bytes array to base64 string
  static String toBase64(Uint8List buffer) {
    // if (buffer == null || buffer.length <= 0) return null;

    final str = base64Encode(buffer);
    return str;
  }

  /// convert base64 string to bytes array
  static Uint8List fromBase64(String base64) {
    // if (base64 == null || base64.length <= 0) return null;

    final data = base64Decode(base64);
    return data;
  }

  /// clone bytes array
  static Uint8List clone(Uint8List origin) {
    // if (origin == null) return null;

    return Uint8List.fromList(origin);
  }

  static bool same(Uint8List bytes1, Uint8List bytes2) {
    // if (bytesFirst == null && bytesSecond == null) return true;
    // if (bytesFirst == null && bytesSecond != null) return false;
    // if (bytesFirst != null && bytesSecond == null) return false;
    // if (bytesFirst!.length != bytesSecond!.length) return false;
    // if (bytesFirst.length == 0 && bytesSecond.length == 0) return true;

    // if (bytes1 == null) return bytes2 == null;
    // if (bytes2 == null) return false;
    if (bytes1.length != bytes2.length) return false;

    for (int i = 0; i < bytes1.length; i++) {
      if (bytes1[i] != bytes2[i]) return false;
    }

    return true;
  }

  static Uint8List? extract(Uint8List input, int index, int length) {
    // if (input == null || input.length <= 0 || length <= 0 || index < 0) {
    //   return null;
    // }

    if (index >= input.length) return null;

    int end = index + length;
    if (end >= input.length) {
      end = input.length;
    }

    final sub = input.sublist(index, end);
    return sub;
  }

  static Uint8List combine(Uint8List array1, Uint8List array2) {
    // var list = Uint8List(array1.length + array2.length);

    // for (int i = 0; i < array1.length; i++) {
    //   list[i] = array1[i];
    // }
    // for (int i = 0; i < array2.length; i++) {
    //   list[array1.length + i] = array2[i];
    // }

    // return Uint8List.fromList(list);
    return insert(array1, array1.length, array2);
  }

  static Uint8List insert(Uint8List origin, int index, Uint8List sub) {
    if (index < 0 || sub.length <= 0) return origin;

    if (origin.length == 0) {
      return Uint8List.fromList(sub);
    }

    final actIndex = index > origin.length ? origin.length : index;

    var list = List<int>.from(origin);
    list.insertAll(actIndex, sub);
    return Uint8List.fromList(list);
  }
}
