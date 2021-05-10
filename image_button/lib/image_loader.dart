import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as libImage;
import 'package:path/path.dart' as p;

/// load asset image
class ImageLoader {
  ImageLoader._(this.assetPath);

  /// asset path
  final String assetPath;

  static var _cache = <String, libImage.Image?>{};

  /// load image by asset path
  static Future<Image?> load({
    /// asset path
    required String assetPath,

    /// crop image area
    Rect? cropRect,
  }) async {
    if (!_cache.containsKey(assetPath)) {
      final loader = ImageLoader._(assetPath);
      final image = await loader._loadLibImage();
      _cache[assetPath] = image;
    }

    final image = _cache[assetPath];
    if (image == null) return null;

    var rect = (cropRect == null)
        ? Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble())
        : cropRect;
    final crop = libImage.copyCrop(image, rect.left.toInt(), rect.top.toInt(),
        rect.width.toInt(), rect.height.toInt());
    final img = Image.memory(
      Uint8List.fromList(libImage.encodePng(crop)),
      width: crop.width.toDouble(),
      height: crop.height.toDouble(),
    );

    return img;
  }

  Future<libImage.Image?> _loadLibImage() async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();

    final decoder = _getDecoderByFileExt();
    if (decoder == null) return null;

    libImage.Image? image = decoder.decodeImage(bytes);
    return image;
  }

  libImage.Decoder? _getDecoderByFileExt() {
    final ext = p.extension(assetPath).toLowerCase();

    switch (ext) {
      case '.jpg':
        return libImage.JpegDecoder();
      case '.png':
        return libImage.PngDecoder();
      case '.bmp':
        return libImage.BmpDecoder();
    }

    return null;
  }
}

/// cimpatible image type
enum ImageType {
  jpg,
  png,
  bmp,
  // tiff,
}
