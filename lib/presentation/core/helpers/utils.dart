import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/widgets/snackbar.dart';

class Utils {
  static showSnackBar(
    BuildContext context, {
    required String msg,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SnackBarContent(
          msg: msg,
        ),
      ),
    );
  }
}
