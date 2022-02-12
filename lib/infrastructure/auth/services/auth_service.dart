import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/auth/services/auth_service.dart';
import 'package:flutter_base/domain/core/error_content.dart';

import 'i_auth_repository.dart';
import 'i_auth_storage_repository.dart';

@LazySingleton(as: AuthService)
class AuthServiceImpl extends AuthService {
  final IAuthDataRepository repository;
  final IAuthStorageRepository localStorage;

  AuthServiceImpl({
    required this.repository,
    required this.localStorage,
  });

  @override
  Future<Either<ErrorContent, User>> login({
    required String username,
    required String password,
    required bool rememberUsername,
  }) async {
    final _userOrFailure = await repository.login(
      username: username,
      password: password,
    );

    _userOrFailure.fold(
      (l) => null,
      (user) {
        if (user.session != null) {
          localStorage.storeSessionInformation(
              sessionInformation: user.session!);
        }
        if (rememberUsername) {
          localStorage.storeUsername(username: username);
        } else {
          //clear username
          localStorage.storeUsername(username: "");
        }
      },
    );
    return _userOrFailure;
  }

  @override
  Future<Either<ErrorContent, User?>> getUserLoggedIn() async {
    final _sessionInfoOrFailure = await localStorage.getSessionInformation();

    return _sessionInfoOrFailure.fold(
      (fail) {
        return Left(fail);
      },
      (session) {
        if (session.sessionExpired()) {
          return Left(ErrorContent.server("Session Expired"));
        }

        return repository.getUserLoggedIn(sessionId: session.sessionId);
      },
    );
  }

  @override
  Future<Either<ErrorContent, Unit>> logout() async {
    await localStorage.clearAllStoredData();
    return repository.logout();
  }

  @override
  Future<Either<ErrorContent, String>> getUsernameRemembered() async {
    return localStorage.getUsername();
  }

  @override
  Future<Either<ErrorContent, ServiceType>> getUserServiceType(
      {required String username}) {
    return repository.getUserServiceType(username: username);
  }
}
