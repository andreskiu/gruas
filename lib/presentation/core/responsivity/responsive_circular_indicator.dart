import 'package:flutter/material.dart';
import 'responsive_calculations.dart';

class ResponsiveCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: Info.verticalUnit / 2,
    );
  }
}
