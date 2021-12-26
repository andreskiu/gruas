import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as ExtImage;
import 'package:location/location.dart';

List<int> _encodeJpgComputation(ExtImage.Image image) {
  return ExtImage.encodeJpg(image);
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

  static Future<ExtImage.Image?> drawWaterMarks(
      ExtImage.Image originalPhoto) async {
    ExtImage.Image waterMark = ExtImage.Image(500, 50);
    final _today = DateTime.now();
    final _todayString = DateFormat.yMd().add_Hm().format(_today);

    waterMark = ExtImage.drawString(
      waterMark,
      ExtImage.arial_48,
      0,
      0,
      _todayString,
    );
    var _photoWithWaterMark = ExtImage.copyInto(originalPhoto, waterMark);
    _photoWithWaterMark = await putLocationWatermark(_photoWithWaterMark);

    return _photoWithWaterMark;
  }

  static Future<ExtImage.Image> putLocationWatermark(
      ExtImage.Image origin) async {
    try {
      Location locationService = Location();
      final _currentLocation = await locationService.getLocation();
      final latitudeWaterMark = ExtImage.drawString(
        ExtImage.Image(350, 50),
        ExtImage.arial_48,
        0,
        0,
        'lat ' + _currentLocation.latitude.toString(),
      );
      final longitudeWaterMark = ExtImage.drawString(
        ExtImage.Image(350, 50),
        ExtImage.arial_48,
        0,
        0,
        'lng ' + _currentLocation.longitude.toString(),
      );
      var _finalPhoto = ExtImage.copyInto(
        origin,
        latitudeWaterMark,
        dstY: origin.height - 100,
      );
      _finalPhoto = ExtImage.copyInto(
        _finalPhoto,
        longitudeWaterMark,
        dstY: origin.height - 40,
      );
      return _finalPhoto;
    } on Exception catch (e) {
      print(e.toString());
      return origin;
    }
  }
}
