import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as ExtImage;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

List<int> _encodeJpgComputation(ExtImage.Image image) {
  return ExtImage.encodeJpg(
    image,
  );
}

ExtImage.Image? _decodeImageComputation(Uint8List bytes) {
  return ExtImage.decodeImage(bytes);
}

class ImageHelper {
  static Future<Uint8List> encodeJpg(ExtImage.Image image) async {
    return Uint8List.fromList(await compute(_encodeJpgComputation, image));
  }

  static Future<ExtImage.Image?> decodeImage(Uint8List bytes) async {
    return await compute(_decodeImageComputation, bytes);
  }

  static Future<ExtImage.Image?> putTimeWaterMark(
      ExtImage.Image originalPhoto) async {
    ExtImage.Image waterMark = ExtImage.Image(500, 50);
    final _today = DateTime.now();
    final _todayString = DateFormat('y-MM-dd').add_Hms().format(_today);

    waterMark = ExtImage.drawString(
      waterMark,
      ExtImage.arial_48,
      0,
      0,
      _todayString,
    );
    final _finalPhoto = ExtImage.copyInto(
      originalPhoto,
      waterMark,
      dstY: 20,
      dstX: 5,
    );
    return _finalPhoto;
  }

  static Future<ExtImage.Image> putLocationWatermark(
    ExtImage.Image origin,
    LocationData location,
  ) async {
    try {
      final latitudeWaterMark = ExtImage.drawString(
        ExtImage.Image(350, 50),
        ExtImage.arial_48,
        0,
        0,
        'lat ' + location.latitude.toString(),
      );
      final longitudeWaterMark = ExtImage.drawString(
        ExtImage.Image(350, 50),
        ExtImage.arial_48,
        0,
        0,
        'lng ' + location.longitude.toString(),
      );
      var _finalPhoto = ExtImage.copyInto(
        origin,
        latitudeWaterMark,
        dstY: origin.height - 100,
        dstX: 5,
      );
      _finalPhoto = ExtImage.copyInto(
        _finalPhoto,
        longitudeWaterMark,
        dstY: origin.height - 40,
        dstX: 5,
      );
      return _finalPhoto;
    } on Exception catch (e) {
      print(e.toString());
      return origin;
    }
  }
}
