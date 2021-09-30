import 'package:flutter/material.dart';
import 'responsive_calculations.dart';

class ResponsiveDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).primaryColorDark,
      thickness: Info.verticalUnit / 8,
    );
  }
}
