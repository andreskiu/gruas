import 'package:flutter/material.dart';

import 'responsive_calculations.dart';

class ResponsiveCheckbox extends StatefulWidget {
  ResponsiveCheckbox({
    this.onChange,
    this.initialValue = false,
  });

  final Function(bool)? onChange;
  final bool initialValue;

  @override
  _ResponsiveCheckboxState createState() => _ResponsiveCheckboxState();
}

class _ResponsiveCheckboxState extends State<ResponsiveCheckbox> {
  late bool _isChecked;
  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.scale(
        scale: Info.verticalUnit / 9,
        child: Checkbox(
          value: _isChecked,
          onChanged: (bool) {
            setState(() {
              _isChecked = !_isChecked;
              if (widget.onChange != null) {
                widget.onChange!(_isChecked);
              }
            });
          },
        ),
      ),
    );
  }
}
