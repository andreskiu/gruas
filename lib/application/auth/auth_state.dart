import 'package:flutter/foundation.dart';
import 'package:flutter_base/domain/auth/use_cases/logout.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/auth/use_cases/get_user_logged_in.dart';

@lazySingleton
class AuthState extends ChangeNotifier {
  AuthState._({
    required this.loggedUser,
    required this.getUserLoggedInUseCase,
    required this.logoutUseCase,
  });

  @factoryMethod
  static Future<AuthState> init() async {
    final getUserLoggedInUseCase = GetIt.I.get<GetUserLoggedInUseCase>();
    final logoutUseCase = GetIt.I.get<LogoutUseCase>();
    final _userOrFailure = await getUserLoggedInUseCase(NoParams());

    return AuthState._(
      getUserLoggedInUseCase: getUserLoggedInUseCase,
      loggedUser: _userOrFailure.getOrElse(() => User.empty()),
      logoutUseCase: logoutUseCase,
    );
  }

  User loggedUser;
  final GetUserLoggedInUseCase getUserLoggedInUseCase;
  final LogoutUseCase logoutUseCase;

  Future<bool> logout() async {
    final _logoutOrFailure = await logoutUseCase.call(NoParams());
    if (_logoutOrFailure.isRight()) {
      loggedUser = User.empty();
    }
    notifyListeners();
    return _logoutOrFailure.isRight();
  }

  bool isLoggedIn() {
    return loggedUser != User.empty();
  }
}
