import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../error_content.dart';
import '../value_objects.dart';

class EmailField extends ValueObject<String> {
  factory EmailField(
    String? input, {
    bool mandatory = false,
  }) {
    return EmailField._(
        value: validateEmailAddress(
      input,
      mandatory: mandatory,
    ));
  }

  EmailField._({
    required this.value,
  });

  @override
  final Either<ErrorContent, String> value;
}

Either<ErrorContent, String> validateEmailAddress(
  String? input, {
  bool mandatory = false,
}) {
  const _fieldBase = "core.fields.";
  if (mandatory && (input == null || input.isEmpty)) {
    return Left(ErrorContent.field(tr(_fieldBase + "email.errors.empty")));
  }
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input!)) {
    return Right(input);
  } else {
    return Left(ErrorContent.field(tr(_fieldBase + "email.errors.invalid")));
  }
}
