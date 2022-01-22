import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/value_objects.dart';

class UsernameField extends ValueObject<String> {
  factory UsernameField(
    String? input, {
    bool mandatory = false,
  }) {
    return UsernameField._(
        value: validateUsername(
      input,
      mandatory: mandatory,
    ));
  }

  UsernameField._({
    required this.value,
  });

  @override
  final Either<ErrorContent, String> value;
}

Either<ErrorContent, String> validateUsername(
  String? input, {
  bool mandatory = false,
}) {
  if (mandatory && (input == null || input.isEmpty)) {
    return Left(ErrorContent.field('Usuario es requerido'));
  }

  return Right(input!);
}
