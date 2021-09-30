import 'package:dartz/dartz.dart';

import '../error_content.dart';
import '../value_objects.dart';

class PhoneNumber extends ValueObject<String> {
  factory PhoneNumber(String? input, {bool mandatory = false}) {
    return PhoneNumber._(
        value: validatePhoneNumber(input, mandatory: mandatory));
  }

  PhoneNumber._({
    required this.value,
  });

  @override
  final Either<ErrorContent, String> value;
}

Either<ErrorContent, String> validatePhoneNumber(
  String? input, {
  bool mandatory = false,
}) {
  const _fieldBase = "core.fields.";

  if (mandatory && (input == null || input.isEmpty)) {
    return Left(ErrorContent.field(_fieldBase + "phone.errors.empty"));
  }
  String inputWithoutSimbols = "";
  RegExp(r"(\d)").allMatches(input!).forEach((e) {
    inputWithoutSimbols = inputWithoutSimbols + (e.group(0) ?? "");
  });
  if (!mandatory && input.isEmpty) {
    return Right(inputWithoutSimbols);
  }

  // CHECK THE FOLLOWINGS FORMAT VALIDATIONS AND ADJUST TO FIT YOUR REQUIREMENTS

  // Only US numbers
  if (inputWithoutSimbols[0] != "1") {
    return Left(ErrorContent.field(_fieldBase + "phone.errors.invalid"));
  }
  // 11 AND 12 NUMBERS ALLOWED
  if (inputWithoutSimbols.length < 11 || inputWithoutSimbols.length > 12) {
    return Left(ErrorContent.field(_fieldBase + "phone.errors.invalid"));
  }

  return Right(inputWithoutSimbols);
}
