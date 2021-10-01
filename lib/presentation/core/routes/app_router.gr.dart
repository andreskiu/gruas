// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../../auth/login_page.dart' as _i7;
import '../../feature/service_accepted.dart' as _i5;
import '../../feature/service_details.dart' as _i6;
import '../../splash_page.dart' as _i4;
import 'guards/auth_guards.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter(
      {_i2.GlobalKey<_i2.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i3.AuthGuard authGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i4.SplashScreen();
        }),
    ServiceAcceptedPageRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i5.ServiceAcceptedPage();
        }),
    ServiceDetailsRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i6.ServiceDetails();
        }),
    LoginPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i7.LoginPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        durationInMilliseconds: 1800,
        opaque: true,
        barrierDismissible: false)
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashScreenRoute.name, path: '/'),
        _i1.RouteConfig(ServiceAcceptedPageRoute.name,
            path: '/service-accepted-page', guards: [authGuard]),
        _i1.RouteConfig(ServiceDetailsRoute.name,
            path: '/service-details', guards: [authGuard]),
        _i1.RouteConfig(LoginPageRoute.name, path: '/login-page')
      ];
}

class SplashScreenRoute extends _i1.PageRouteInfo {
  const SplashScreenRoute() : super(name, path: '/');

  static const String name = 'SplashScreenRoute';
}

class ServiceAcceptedPageRoute extends _i1.PageRouteInfo {
  const ServiceAcceptedPageRoute()
      : super(name, path: '/service-accepted-page');

  static const String name = 'ServiceAcceptedPageRoute';
}

class ServiceDetailsRoute extends _i1.PageRouteInfo {
  const ServiceDetailsRoute() : super(name, path: '/service-details');

  static const String name = 'ServiceDetailsRoute';
}

class LoginPageRoute extends _i1.PageRouteInfo {
  const LoginPageRoute() : super(name, path: '/login-page');

  static const String name = 'LoginPageRoute';
}
