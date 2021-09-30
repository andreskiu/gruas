import 'package:auto_route/auto_route.dart';
import 'package:flutter_base/application/auth/auth_state.dart';

import 'package:flutter_base/presentation/core/routes/app_router.gr.dart';
import 'package:get_it/get_it.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final _authState = GetIt.I.get<AuthState>();

    if (_authState.isLoggedIn()) {
      resolver.next(true);
    } else {
      router.removeUntil((route) => true);

      router.push(LoginPageRoute());
      resolver.next(false);
    }
  }
}
