import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/auth/services/auth_service.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUserLoggedInUseCase extends UseCase<User, NoParams> {
  final AuthService service;

  GetUserLoggedInUseCase(this.service);

  @override
  Future<Either<ErrorContent, User>> call(
    NoParams params,
  ) async {
    final result = await service.getUserLoggedIn();

    return result.fold(
      (fail) => Left(fail),
      (user) {
        if (user == null) {
          return Left(
            ErrorContent.useCase('Ningún usuario esta logueado'),
          );
        }
        return Right(user);
      },
    );
  }
}
