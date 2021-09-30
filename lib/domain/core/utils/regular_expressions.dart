import 'constants.dart';

class RegPattern {
  static const containsAtLeastOneLowerCaseLetter = r"[a-z]{1}";
  static const mustStartWithALetter = r"^[a-zA-Z]{1}";
  static const containsAtLeastOneUpperCaseLetter = r"[A-Z]{1}";
  static const containsAtLeastThreeNumbers =
      r"(.*[0-9]){" + MinPasswordNumbers + "}";

  static const containsAtLeastOneSymbol =
      r'[¡!@#$%^&*(),.¿?:{}|\-\_=<>\\/¬+;]{1}';
}
