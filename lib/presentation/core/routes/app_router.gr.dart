// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../../../domain/grua/models/service.dart' as _i9;
import '../../auth/login_page.dart' as _i5;
import '../../grua/service_accepted_page.dart' as _i2;
import '../../grua/service_details_page.dart' as _i3;
import '../../peripherals/scan_qr_page.dart' as _i4;
import '../../splash_page.dart' as _i1;
import 'guards/auth_guards.dart' as _i8;

class AppRouter extends _i6.RootStackRouter {
  AppRouter(
      {_i7.GlobalKey<_i7.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i8.AuthGuard authGuard;

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData, child: _i1.SplashScreen());
    },
    ServiceAcceptedPageRoute.name: (routeData) {
      final args = routeData.argsAs<ServiceAcceptedPageRouteArgs>();
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i2.ServiceAcceptedPage(key: args.key, service: args.service));
    },
    ServiceDetailsRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.ServiceDetails());
    },
    ScanQRPageRoute.name: (routeData) {
      return _i6.AdaptivePage<String?>(
          routeData: routeData, child: _i4.ScanQRPage());
    },
    LoginPageRoute.name: (routeData) {
      return _i6.CustomPage<dynamic>(
          routeData: routeData,
          child: _i5.LoginPage(),
          transitionsBuilder: _i6.TransitionsBuilders.fadeIn,
          durationInMilliseconds: 1800,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(SplashScreenRoute.name, path: '/'),
        _i6.RouteConfig(ServiceAcceptedPageRoute.name,
            path: '/service-accepted-page', guards: [authGuard]),
        _i6.RouteConfig(ServiceDetailsRoute.name,
            path: '/service-details', guards: [authGuard]),
        _i6.RouteConfig(ScanQRPageRoute.name, path: '/scan-qr-page'),
        _i6.RouteConfig(LoginPageRoute.name, path: '/login-page')
      ];
}

/// generated route for [_i1.SplashScreen]
class SplashScreenRoute extends _i6.PageRouteInfo<void> {
  const SplashScreenRoute() : super(name, path: '/');

  static const String name = 'SplashScreenRoute';
}

/// generated route for [_i2.ServiceAcceptedPage]
class ServiceAcceptedPageRoute
    extends _i6.PageRouteInfo<ServiceAcceptedPageRouteArgs> {
  ServiceAcceptedPageRoute({_i7.Key? key, required _i9.Service service})
      : super(name,
            path: '/service-accepted-page',
            args: ServiceAcceptedPageRouteArgs(key: key, service: service));

  static const String name = 'ServiceAcceptedPageRoute';
}

class ServiceAcceptedPageRouteArgs {
  const ServiceAcceptedPageRouteArgs({this.key, required this.service});

  final _i7.Key? key;

  final _i9.Service service;
}

/// generated route for [_i3.ServiceDetails]
class ServiceDetailsRoute extends _i6.PageRouteInfo<void> {
  const ServiceDetailsRoute() : super(name, path: '/service-details');

  static const String name = 'ServiceDetailsRoute';
}

/// generated route for [_i4.ScanQRPage]
class ScanQRPageRoute extends _i6.PageRouteInfo<void> {
  const ScanQRPageRoute() : super(name, path: '/scan-qr-page');

  static const String name = 'ScanQRPageRoute';
}

/// generated route for [_i5.LoginPage]
class LoginPageRoute extends _i6.PageRouteInfo<void> {
  const LoginPageRoute() : super(name, path: '/login-page');

  static const String name = 'LoginPageRoute';
}
