import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_base/domain/auth/fields/password_field.dart';
import 'package:flutter_base/domain/auth/fields/username_field.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/auth/services/auth_service.dart';
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
    final _paramsError = params.areValid();
    if (_paramsError != null) {
      return Left(_paramsError);
    }

    final _userOrfailure = await service.login(
      username: params.username,
      password: params.password,
      rememberUsername: params.rememberUsername,
    );

    if (_userOrfailure.isLeft()) {
      return Left(ErrorContent.useCase("Credenciales no válidas"));
    }
    final _user = _userOrfailure.getOrElse(() => User.empty());
    final _serviceTypeOrFailure = await service.getUserServiceType(
      username: params.username,
    );
    return _serviceTypeOrFailure.fold(
      (fail) {
        return Left(ErrorContent.useCase("Credenciales no válidas"));
      },
      (type) async {
        if (type == ServiceType.grua) {
          await FirebaseMessaging.instance.subscribeToTopic('grua');
        }
        if (type == ServiceType.carroTaller) {
          await FirebaseMessaging.instance.subscribeToTopic('carroTaller');
        }
        if (type == ServiceType.motoTaller) {
          await FirebaseMessaging.instance.subscribeToTopic('motoTaller');
        }

        return Right(_user.copyWith(serviceOffered: type));
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
