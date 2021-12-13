import 'package:dartz/dartz.dart';

import '../error_content.dart';

abstract class Functions {
  static Type getValue(Either<ErrorContent, Type> valueOrFailure) {
    late Type value;
    if (valueOrFailure.isLeft()) {
      throw Exception("Right is expected, but got Left");
    }
    valueOrFailure.fold((l) => null, (r) => value = r);
    return value;
  }

  static ErrorContent getError(Either<ErrorContent, Type> valueOrFailure) {
    late ErrorContent error;
    if (valueOrFailure.isRight()) {
      throw Exception("Left is expected, but got Right");
    }
    valueOrFailure.fold((l) => error = l, (r) => null);
    return error;
  }
}
