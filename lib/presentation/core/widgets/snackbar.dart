import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';

class SnackBarContent extends StatelessWidget {
  final String msg;
  final bool isError;
  const SnackBarContent({
    Key key = const Key("snackBarContent"),
    required this.msg,
    this.isError = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
        ),
        SizedBox(width: Info.horizontalUnit * 4),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: ResponsiveText(
              msg,
              color: Theme.of(context).snackBarTheme.contentTextStyle!.color,
            ),
          ),
        ),
      ],
    );
  }
}
