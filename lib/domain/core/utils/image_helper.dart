import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as ExtImage;

List<int> _encodeJpgComputation(ExtImage.Image image) {
  return ExtImage.encodeJpg(image);
}

ExtImage.Image? _decodeImageComputation(Uint8List bytes) {
  return ExtImage.decodeImage(bytes);
}

class ImageHelper {
  static bool isRemote({
    required String path,
  }) {
    return path.contains('http://') || path.contains('https://');
  }

  // static Future<Size> getSize({
  //   required String path,
  // }) async {
  //   final _file = isRemote(path: path)
  //       ? await DefaultCacheManager().getSingleFile(path)
  //       : File(path);

  //   final _imageBytes = await _file.readAsBytes();
  //   ExtImage.Image? _image = await decodeImage(_imageBytes);

  //   if (_image == null) return Size.zero;

  //   return Size(
  //     _image.width.toDouble(),
  //     _image.height.toDouble(),
  //   );
  // }

  // static Future<ExtImage.Image?> transform({
  //   required String path,
  //   required Matrix4 matrix,
  //   required double viewportScale,
  //   required Size viewportSize,
  //   required int maxWidth,
  //   required int maxHeight,
  // }) async {
  //   final double scale = matrix.row0[0] * viewportScale;
  //   final int xOffset = (matrix.row0[3] / scale).round().abs();
  //   final int yOffset = (matrix.row1[3] / scale).round().abs();
  //   final int croppedWidth = (viewportSize.width / scale).round();
  //   final int croppedHeight = (viewportSize.height / scale).round();

  //   final _file = isRemote(path: path)
  //       ? await DefaultCacheManager().getSingleFile(path)
  //       : File(path);

  //   final _imageBytes = await _file.readAsBytes();
  //   ExtImage.Image? _image = await decodeImage(_imageBytes);

  //   if (_image == null) return null;

  //   // Crops the image if needed
  //   final _imageSize = await getSize(path: path);
  //   if (xOffset + croppedWidth < _imageSize.width ||
  //       yOffset + croppedHeight < _imageSize.height) {
  //     _image = ExtImage.copyCrop(
  //       _image,
  //       xOffset,
  //       yOffset,
  //       croppedWidth,
  //       croppedHeight,
  //     );
  //   }

  //   // Resizes the image if needed
  //   if (croppedWidth > maxWidth) {
  //     _image = ExtImage.copyResize(
  //       _image,
  //       width: maxWidth,
  //     );
  //   } else if (croppedHeight > maxHeight) {
  //     _image = ExtImage.copyResize(
  //       _image,
  //       height: maxHeight,
  //     );
  //   }

  //   return _image;
  // }

  // static Future<ExtImage.Image?> getJpg({
  //   required String path,
  // }) async {
  //   final _file = isRemote(path: path)
  //       ? await DefaultCacheManager().getSingleFile(path)
  //       : File(path);

  //   final _imageBytes = await _file.readAsBytes();
  //   return await decodeImage(_imageBytes);
  // }

  // static Future<Uint8List> getJpgBytes({
  //   required String path,
  // }) async {
  //   ExtImage.Image? _image = await getJpg(path: path);
  //   if (_image == null) {
  //     return Uint8List.fromList([]);
  //   }
  //   return Uint8List.fromList(await encodeJpg(_image));
  // }

  static Future<Uint8List> encodeJpg(ExtImage.Image image) async {
    return Uint8List.fromList(await compute(_encodeJpgComputation, image));
  }

  static Future<ExtImage.Image?> decodeImage(Uint8List bytes) async {
    return await compute(_decodeImageComputation, bytes);
  }
}
