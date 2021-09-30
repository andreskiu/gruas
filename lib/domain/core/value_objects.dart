import 'package:dartz/dartz.dart';

import 'error_content.dart';

abstract class ValueObject<T> {
  const ValueObject();

  Either<ErrorContent, T?> get value;

  bool isValid() => value.isRight();

// This function doesn't work
  // T? getValue() => value.getOrElse(() => null);
  T? getValue() => value.fold((l) => null, (value) => value);

  ErrorContent? getError<T, R>() => value.fold((l) => l, (_) => null);

  // String? getError() {
  //   return this.getFailure()?.getError().message;
  //   // if (_error == null) {
  //   //   return "";
  //   // }
  //   // return _error.message;
  // }
}
