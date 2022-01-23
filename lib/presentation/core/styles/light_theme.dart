import 'package:flutter/material.dart';

class ColorPaletteLight implements ColorPalette {
  final _white = Colors.white;
  final _black = Colors.black;

  final _greyDisabled = Color(0xFFb5b3b3);

  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get primaryColor => Color.fromARGB(255, 53, 87, 73);

  @override
  Color get primaryColorDisabled => primaryColor.withOpacity(0.7);

  @override
  Color get primaryColorDark => primaryColor.withOpacity(0.7);

  @override
  Color get successColor => Color.fromARGB(255, 147, 210, 15);

  @override
  Color? get accentColor => null;

  @override
  Color get backgroundColor => Colors.grey[100]!;

  @override
  Color get fillColor => Colors.grey[300]!;

  @override
  Color get errorColor => Color(0xFFb40a1a);

  @override
  Color get iconOnBackgroundColor => primaryColor;

  @override
  Color get iconOnBackgroundColorDisabled => _greyDisabled;

  @override
  Color get iconOnPrimaryColor => _white;

  @override
  Color get iconOnPrimaryColorDisabled => _greyDisabled;

// Text colors
  @override
  Color get textOnBackgroundColor => _black;

  @override
  Color get textOnBackgroundColorSoft => Colors.black54;

  @override
  Color get textOnBackgroundColorDisabled => _greyDisabled;

  @override
  Color get textOnPrimaryColor => _white;

  @override
  Color get textOnPrimaryColorSoft => Colors.white70;

  @override
  Color get textOnPrimaryColorDisabled => _greyDisabled;
}

abstract class ColorPalette {
  Brightness get brightness;
  Color get primaryColor;
  Color get primaryColorDark;
  Color get primaryColorDisabled;

  Color? get accentColor;

  Color? get backgroundColor;
  Color? get fillColor;

  Color get successColor;
  Color get errorColor;

  //text colors
  Color get textOnBackgroundColor;
  Color get textOnBackgroundColorSoft;
  Color get textOnBackgroundColorDisabled;

  Color get textOnPrimaryColor;
  Color get textOnPrimaryColorSoft;
  Color get textOnPrimaryColorDisabled;

  //icons colors
  Color get iconOnBackgroundColor;
  Color get iconOnBackgroundColorDisabled;
  Color get iconOnPrimaryColor;
  Color get iconOnPrimaryColorDisabled;
}

ThemeData getThemeData(ColorPalette palette) {
  ThemeData theme;
  if (palette.brightness == Brightness.light) {
    theme = ThemeData.light();
  } else {
    theme = ThemeData.dark();
  }

  return theme.copyWith(
    primaryColor: palette.primaryColor,
    primaryColorDark: palette.primaryColorDark,
    appBarTheme: AppBarTheme(
      color: palette.primaryColor,
    ),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.errorColor,
        contentTextStyle: TextStyle(color: palette.textOnPrimaryColor)),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: palette.primaryColor,
    ),
    accentColor: palette.accentColor,
    backgroundColor: palette.backgroundColor,
    scaffoldBackgroundColor: palette.backgroundColor,
    errorColor: palette.errorColor,
    buttonTheme: ButtonThemeData(),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(
        palette.backgroundColor,
      ),
      fillColor: MaterialStateProperty.all(
        palette.primaryColor,
      ),
    ),
    canvasColor: palette.backgroundColor,
    iconTheme: IconThemeData(
      color: palette.primaryColorDark,
    ),
    indicatorColor: palette.primaryColor,
    primaryTextTheme: TextTheme(
      // Header text on background color
      headline1: TextStyle(
        color: palette.textOnPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
      // Header text on primary color
      headline2: TextStyle(
        color: palette.textOnBackgroundColor,
        fontWeight: FontWeight.bold,
      ),
      // standard app text on background color
      bodyText1: TextStyle(
        color: palette.textOnBackgroundColor,
      ),
      // standard app text on primary color
      bodyText2: TextStyle(
        color: palette.textOnPrimaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(MaterialState.disabled)) {
            return TextStyle(
              color: palette.textOnPrimaryColorDisabled,
            );
          }
          return TextStyle(
            color: palette.textOnPrimaryColor,
          );
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return palette.primaryColorDisabled;
          }
          return palette.primaryColor;
        }),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(MaterialState.disabled)) {
            return TextStyle(
              color: palette.textOnBackgroundColorDisabled,
            );
          }
          return TextStyle(
            color: palette.textOnBackgroundColor,
          );
        }),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: palette.textOnBackgroundColor,
      ),
      fillColor: palette.fillColor,
      hintStyle: TextStyle(
        color: palette.textOnBackgroundColorSoft,
      ),
      helperStyle: TextStyle(
        color: palette.textOnBackgroundColorSoft,
      ),
      errorStyle: TextStyle(
        color: palette.errorColor,
      ),
    ),
  );
}
