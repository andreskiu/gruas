import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';

abstract class IAuthDataRepository {
  Future<Either<ErrorContent, User>> login({
    required String username,
    required String password,
  });

  Future<Either<ErrorContent, Unit>> logout();

  Future<Either<ErrorContent, User?>> getUserLoggedIn({
    required String sessionId,
  });

  Future<Either<ErrorContent, ServiceType>> getUserServiceType({
    required String username,
  });
}
