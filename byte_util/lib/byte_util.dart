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
  static String? toReadable(Uint8List? buffer, {Radix radix = Radix.hex}) {
    if (buffer == null || buffer.length <= 0) return null;

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
  static String? toBase64(Uint8List? buffer) {
    if (buffer == null || buffer.length <= 0) return null;

    final str = base64Encode(buffer);
    return str;
  }

  /// convert base64 string to bytes array
  static Uint8List? fromBase64(String? base64) {
    if (base64 == null || base64.length <= 0) return null;

    final data = base64Decode(base64);
    return data;
  }

  /// clone bytes array
  static Uint8List? clone(Uint8List? origin) {
    if (origin == null) return null;

    return Uint8List.fromList(origin);
  }

  static bool same(Uint8List? bytesFirst, Uint8List? bytesSecond) {
    if (bytesFirst == null && bytesSecond == null) return true;
    if (bytesFirst == null && bytesSecond != null) return false;
    if (bytesFirst != null && bytesSecond == null) return false;
    if (bytesFirst!.length != bytesSecond!.length) return false;
    if (bytesFirst.length == 0 && bytesSecond.length == 0) return true;

    for (int i = 0; i < bytesFirst.length; i++) {
      if (bytesFirst[i] != bytesSecond[i]) return false;
    }

    return true;
  }
}
