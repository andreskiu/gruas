import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';

abstract class AuthService {
  Future<Either<ErrorContent, User>> login({
    required String username,
    required String password,
    required bool rememberUsername,
  });

  Future<Either<ErrorContent, Unit>> logout();

  Future<Either<ErrorContent, User?>> getUserLoggedIn();

  Future<Either<ErrorContent, String>> getUsernameRemembered();
}
