import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/domain/auth/fields/password_field.dart';
import 'package:flutter_base/domain/auth/use_cases/get_user_remembered.dart';
import 'package:flutter_base/domain/auth/use_cases/login.dart';
import 'package:flutter_base/domain/core/core_fields/email_field.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';

@injectable
class LoginPageState extends ChangeNotifier {
  LoginUseCase loginUseCase;
  AuthState authState;
  GetUserRememberedUseCase getUserRememberedUseCase;

  LoginPageState({
    required this.loginUseCase,
    required this.authState,
    required this.getUserRememberedUseCase,
  });

  bool rememberMe = false;
  String username = "";
  bool isLoading = false;
  ErrorContent? error;

  Future<String> getRememberedUser() async {
    final usernameOrFailure = await getUserRememberedUseCase.call(NoParams());
    if (usernameOrFailure.isRight()) {
      username = usernameOrFailure.getOrElse(() => "");
      rememberMe = true;
    }
    notifyListeners();
    return username;
  }

  Future<bool> login(
    EmailField email,
    PasswordField psw,
    bool rememberMe,
  ) async {
    isLoading = true;
    notifyListeners();
    final _params = LoginParams(
      email: email,
      password: psw,
      rememberUsername: rememberMe,
    );
    final _userOrFailure = await loginUseCase.call(_params);

    _userOrFailure.fold((fail) {
      error = fail;
    }, (user) {
      authState.loggedUser = user;
    });

    isLoading = false;
    notifyListeners();
    return _userOrFailure.isRight();
  }
}
