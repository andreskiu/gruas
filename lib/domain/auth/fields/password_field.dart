import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
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
  const _fieldBase = "auth.fields.";
  // const field = AuthFields.Password;
  if (input == null || input.isEmpty) {
    return Left(ErrorContent.field(_fieldBase + "password.errors.empty"));
  }

  if (validateSecurity) {
    if (input.length < MinPasswordLength) {
      return Left(ErrorContent.field(
          tr(_fieldBase + "password.errors.minimumCharacters", namedArgs: {
        "length": MinPasswordLength.toString(),
      })));
    }
    if (!RegExp(RegPattern.containsAtLeastOneLowerCaseLetter).hasMatch(input)) {
      return Left(ErrorContent.field(tr(
        _fieldBase + "password.errors.lowercaseCharacter",
      )));
    }
    if (!RegExp(RegPattern.containsAtLeastOneUpperCaseLetter).hasMatch(input)) {
      return Left(ErrorContent.field(
          tr(_fieldBase + "password.errors.uppercaseCharacter")));
    }
    if (!RegExp(RegPattern.containsAtLeastThreeNumbers).hasMatch(input)) {
      return Left(ErrorContent.field(
          tr(_fieldBase + "password.errors.minimumNumbers", namedArgs: {
        "length": MinPasswordNumbers,
      })));
    }
    if (!RegExp(RegPattern.containsAtLeastOneSymbol).hasMatch(input)) {
      return Left(
          ErrorContent.field(tr(_fieldBase + "password.errors.containSymbol")));
    }
    return Right(input);
  }
  return Right(input);
}
