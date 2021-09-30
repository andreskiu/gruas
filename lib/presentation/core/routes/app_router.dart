import 'package:auto_route/auto_route.dart';
import 'package:flutter_base/presentation/auth/login_page.dart';
import 'package:flutter_base/presentation/core/routes/guards/auth_guards.dart';
import 'package:flutter_base/presentation/feature/home_page.dart';
import '../../splash_page.dart';

// @CupertinoAutoRouter
// @AdaptiveAutoRouter
// @CustomAutoRouter
@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: HomePage, guards: [AuthGuard]),
    CustomRoute(
      page: LoginPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 1800,
    )
  ],
  preferRelativeImports: true,
)
class $AppRouter {}
