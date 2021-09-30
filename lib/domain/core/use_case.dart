import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'error_content.dart';

abstract class UseCase<Type, Params> {
  Future<Either<ErrorContent, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
