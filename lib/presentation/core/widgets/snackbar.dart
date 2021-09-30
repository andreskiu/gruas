import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';

class SnackBarContent extends StatelessWidget {
  final String msg;
  final bool isError;
  const SnackBarContent({
    Key key = const Key("snackBarContent"),
    required this.msg,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.ac_unit),
        SizedBox(width: Info.horizontalUnit * 2),
        ResponsiveText(msg),
      ],
    );
  }
}
