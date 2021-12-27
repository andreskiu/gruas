import 'package:flutter/foundation.dart';
import 'package:flutter_base/domain/auth/fields/username_field.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/grua/use_cases/get_evidence_types.dart';
import 'package:get_it/get_it.dart';
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
  final _getEvidenceTypesUseCase = GetIt.I.get<GetEvidenceTypesUseCase>();
  LoginUseCase loginUseCase;
  GetUserRememberedUseCase getUserRememberedUseCase;

  LoginPageState({
    required this.loginUseCase,
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
      rememberMe = username.isNotEmpty;
    }
    notifyListeners();
    return username;
  }

  Future<bool> login(
    UsernameField username,
    PasswordField psw,
    bool rememberMe,
  ) async {
    isLoading = true;
    notifyListeners();
    final _params = LoginParams(
      username: username.getValue() ?? '',
      password: psw.getValue() ?? '',
      rememberUsername: rememberMe,
    );
    final _userOrFailure = await loginUseCase.call(_params);

    _userOrFailure.fold((fail) {
      error = fail;
    }, (user) async {
      final _authState = await GetIt.I.getAsync<AuthState>();
      _authState.loggedUser = user;
    });
    await cacheEvidenceTypes();
    isLoading = false;
    notifyListeners();
    return _userOrFailure.isRight();
  }

  Future<void> cacheEvidenceTypes() async {
    await _getEvidenceTypesUseCase.call(NoParams());
  }
}
