import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/grua/save_photo_modal.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';

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

    return _originalPhoto;
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
