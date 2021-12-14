import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/auth/fields/password_field.dart';
import 'package:flutter_base/domain/auth/fields/username_field.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/auth/services/auth_service.dart';
import 'package:flutter_base/domain/core/core_fields/email_field.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoginUseCase extends UseCase<User, LoginParams> {
  final AuthService service;

  LoginUseCase(this.service);

  @override
  Future<Either<ErrorContent, User>> call(
    LoginParams params,
  ) async {
    const _useCaseBase = "auth.";
    final _paramsError = params.areValid();
    if (_paramsError != null) {
      return Left(_paramsError);
    }

    final result = await service.login(
      username: params.username,
      password: params.password,
      rememberUsername: params.rememberUsername,
    );

    return result.fold(
      (fail) {
        return Left(ErrorContent.useCase(
            _useCaseBase + "login.errors.invalid_credentials"));
      },
      (user) {
        return Right(user);
      },
    );
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;
  final bool rememberUsername;

  LoginParams({
    required this.username,
    required this.password,
    required this.rememberUsername,
  });

  ErrorContent? areValid() {
    final _username = UsernameField(username);
    if (!_username.isValid()) {
      return _username.getError();
    }
    final _psw = PasswordField(
      password,
      validateSecurity: false,
    );
    if (!_psw.isValid()) {
      return _username.getError();
    }
    return null;
  }

  @override
  List<Object> get props => [
        username,
        password,
      ];
}
