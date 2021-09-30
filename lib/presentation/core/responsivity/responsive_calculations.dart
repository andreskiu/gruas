import 'package:flutter/material.dart';

import 'device_detector_widget.dart';

class Info {
  // MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double horizontalUnit;
  static late double verticalUnit;
  static late Orientation orientation;
  static late DeviceScreenType deviceScreenType;
  static late EdgeInsets safeAreaPadding;

  late double _safeAreaHorizontal;
  late double _safeAreaVertical;
  double? safeBlockHorizontal;
  double? safeBlockVertical;

  Info({
    required MediaQueryData mediaQueryData,
  }) {
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    horizontalUnit = screenWidth / 100;
    verticalUnit = screenHeight / 100;

    _safeAreaHorizontal =
        mediaQueryData.padding.left + mediaQueryData.padding.right;
    _safeAreaVertical =
        mediaQueryData.padding.top + mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    orientation = mediaQueryData.orientation;
    deviceScreenType = getDeviceType(mediaQueryData);
    safeAreaPadding = mediaQueryData.padding;
  }

  static double responsiveFontSize(int fontSize) {
    final _factor = (fontSize + 1) / 10;
    final _resizedFontSize = _factor * Info.verticalUnit;
    return _resizedFontSize;
  }
}
