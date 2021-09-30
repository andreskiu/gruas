import 'package:flutter/material.dart';

/// Enums for different screen sizes
enum DeviceScreenType { Mobile, Tablet, PC }

/// GetDeviceType Function
/// This is where we define our screen widths for different layouts
DeviceScreenType getDeviceType(MediaQueryData mediaQueryData) {
  var orientation = mediaQueryData.orientation;

  var deviceWidth = 0.0;

  if (orientation == Orientation.landscape) {
    deviceWidth = mediaQueryData.size.height;
  } else {
    deviceWidth = mediaQueryData.size.width;
  }

  if (deviceWidth > 1000) {
    return DeviceScreenType.PC;
  }

  if (deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}

class OrientationLayout extends StatelessWidget {
  final Widget Function() landscape;
  final Widget Function()? portrait;

  OrientationLayout({
    Key? key,
    required this.landscape,
    this.portrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return landscape();
    }

    return portrait!();
  }
}

class DeviceLayoutSelector extends StatelessWidget {
  final Widget Function(BuildContext buildContext) mobileBuilder;
  final Widget Function(BuildContext buildContext)? tabletBuilder;
  final Widget Function(BuildContext buildContext)? pcBuilder;

  const DeviceLayoutSelector({
    Key? key,
    required this.mobileBuilder,
    this.tabletBuilder,
    this.pcBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _device = getDeviceType(MediaQuery.of(context));
    switch (_device) {
      case DeviceScreenType.Mobile:
        return mobileBuilder(context);

      case DeviceScreenType.Tablet:
        return tabletBuilder!(context);

      case DeviceScreenType.PC:
        return pcBuilder!(context);

      default:
        return mobileBuilder(context);
    }
  }
}
