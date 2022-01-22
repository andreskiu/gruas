import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/services/auth_service.dart';
import 'package:flutter_base/domain/core/use_case.dart';

@lazySingleton
class GetUserRememberedUseCase extends UseCase<String, NoParams> {
  final AuthService service;

  GetUserRememberedUseCase(this.service);

  @override
  Future<Either<ErrorContent, String>> call(
    NoParams params,
  ) async {
    final result = await service.getUsernameRemembered();

    return result.fold(
      (fail) => Left(fail),
      (username) {
        if (username.isEmpty) {
          return Left(
            ErrorContent.useCase('Ningún usuario esta logueado'),
          );
        }
        return Right(username);
      },
    );
  }
}
