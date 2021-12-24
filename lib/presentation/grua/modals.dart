import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/grua/save_photo_modal.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class Modals {
  static Future<im.Image?> takeFoto(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final _photo = await _picker.pickImage(source: ImageSource.camera);
    if (_photo == null) {
      return null;
    }

    final _photoBytes = await _photo.readAsBytes();

    final _originalPhoto = im.decodeImage(_photoBytes);

    // Draw some text using 24pt arial fontif()
    if (_originalPhoto == null) {
      return null;
    }

    im.Image waterMark = im.Image(500, 50);
    final _today = DateTime.now();
    final _todayString = DateFormat.yMd().add_Hm().format(_today);

    waterMark = im.drawString(
      waterMark,
      im.arial_48,
      0,
      0,
      _todayString,
    );
    var _photoWithWaterMark = im.copyInto(_originalPhoto, waterMark);
    _photoWithWaterMark = await putLocationWatermark(_photoWithWaterMark);

    return _photoWithWaterMark;
  }

  static Future<im.Image> putLocationWatermark(im.Image origin) async {
    try {
      Location locationService = Location();
      final _currentLocation = await locationService.getLocation();
      final latitudeWaterMark = im.drawString(
        im.Image(350, 50),
        im.arial_48,
        0,
        0,
        'lat ' + _currentLocation.latitude.toString(),
      );
      final longitudeWaterMark = im.drawString(
        im.Image(350, 50),
        im.arial_48,
        0,
        0,
        'lng ' + _currentLocation.longitude.toString(),
      );
      var _finalPhoto = im.copyInto(
        origin,
        latitudeWaterMark,
        dstY: origin.height - 100,
      );
      _finalPhoto = im.copyInto(
        _finalPhoto,
        longitudeWaterMark,
        dstY: origin.height - 40,
      );
      return _finalPhoto;
    } on Exception catch (e) {
      return origin;
    }
  }

  static Future<bool> showSaveFotoModal(
    BuildContext context,
    im.Image? photo,
  ) async {
    const _borderRadius = 8;
    final _success = await showModalBottomSheet(
        context: context,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Info.horizontalUnit * _borderRadius),
            topLeft: Radius.circular(Info.horizontalUnit * _borderRadius),
          ),
          side: BorderSide(
            color: Colors.black54,
            width: 0.5,
          ),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: Info.horizontalUnit * _borderRadius),
            child: SaveFotoModal(
              photo: photo,
            ),
          );
        });

    return _success ?? false;
  }
}
