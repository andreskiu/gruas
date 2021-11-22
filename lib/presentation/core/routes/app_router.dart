import 'package:auto_route/auto_route.dart';
import 'package:flutter_base/presentation/auth/login_page.dart';
import 'package:flutter_base/presentation/core/routes/guards/auth_guards.dart';
import 'package:flutter_base/presentation/peripherals/scan_qr_page.dart';
import 'package:flutter_base/presentation/grua/service_accepted_page.dart';
import 'package:flutter_base/presentation/grua/service_details_page.dart';
import '../../splash_page.dart';

// @CupertinoAutoRouter
// @AdaptiveAutoRouter
// @CustomAutoRouter
@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: ServiceAcceptedPage, guards: [AuthGuard]),
    AutoRoute(page: ServiceDetails, guards: [AuthGuard]),
    AutoRoute<String?>(
      page: ScanQRPage,
    ),
    CustomRoute(
      page: LoginPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 1800,
    )
  ],
  preferRelativeImports: true,
)
class $AppRouter {}
