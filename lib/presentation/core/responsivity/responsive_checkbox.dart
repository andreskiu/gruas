import 'package:flutter/material.dart';

import 'responsive_calculations.dart';

class ResponsiveCheckbox extends StatelessWidget {
  ResponsiveCheckbox({
    this.onChange,
    this.value = false,
  });

  final Function(bool?)? onChange;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.scale(
        scale: Info.verticalUnit / 8,
        child: Checkbox(
          value: value,
          onChanged: onChange,
        ),
      ),
    );
  }
}
