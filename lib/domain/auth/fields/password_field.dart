import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/utils/constants.dart';
import 'package:flutter_base/domain/core/utils/regular_expressions.dart';
import 'package:flutter_base/domain/core/value_objects.dart';

class PasswordField extends ValueObject<String> {
  factory PasswordField(
    String? input, {
    bool validateSecurity = false,
  }) {
    return PasswordField._(
        value: validatePassword(
      input,
      validateSecurity: validateSecurity,
    ));
  }

  PasswordField._({
    required this.value,
  });

  @override
  final Either<ErrorContent, String> value;
}

Either<ErrorContent, String> validatePassword(
  String? input, {
  bool validateSecurity = false,
}) {
  if (input == null || input.isEmpty) {
    return Left(ErrorContent.field("La contraseña es requerida"));
  }

  if (validateSecurity) {
    if (input.length < MinPasswordLength) {
      return Left(ErrorContent.field(
          "La contraseña debe contener al menos {length} caracteres"));
    }
    if (!RegExp(RegPattern.containsAtLeastOneLowerCaseLetter).hasMatch(input)) {
      return Left(ErrorContent.field(
          "La contraseña debe contener al menos {length} caracteres"));
    }
    if (!RegExp(RegPattern.containsAtLeastOneUpperCaseLetter).hasMatch(input)) {
      return Left(ErrorContent.field(
          "La contraseña debe contener una letra mayúscula"));
    }
    if (!RegExp(RegPattern.containsAtLeastThreeNumbers).hasMatch(input)) {
      return Left(ErrorContent.field(
          "La contraseña debe contener al menos {length} números"));
    }
    if (!RegExp(RegPattern.containsAtLeastOneSymbol).hasMatch(input)) {
      return Left(ErrorContent.field("La contraseña debe contener un simbolo"));
    }
    return Right(input);
  }
  return Right(input);
}
