import 'package:flutter/material.dart';

import 'responsive_calculations.dart';

class ResponsiveIconButton extends StatelessWidget {
  final double size;
  final Function()? onPressed;
  late final IconData icon;
  ResponsiveIconButton({
    Key? key,
    required this.size,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: Info.verticalUnit * size,
        color: Theme.of(context).iconTheme.color,
      ),
      constraints: BoxConstraints.tightFor(
        width: Info.verticalUnit * size,
        height: Info.verticalUnit * size,
      ),
      splashRadius: Info.verticalUnit * size,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
    );
  }
}
