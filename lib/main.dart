import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/styles/light_theme.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/routes/guards/auth_guards.dart';

import 'application/auth/auth_state.dart';
import 'config/injectable/injectable.dart';
import 'presentation/core/routes/app_router.gr.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    initConfig(),
  ]);
  runApp(
    EasyLocalization(
      // For translation to work on iOS you need to add supported locales
      // to ios/Runner/Info.plist. Look for easy_localization documentation
      supportedLocales: [Locale('en'), Locale('es')],
      path: 'assets/i18n',
      fallbackLocale: Locale('en'),
      useOnlyLangCode: true,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter(authGuard: AuthGuard());
  AuthState? _authState;

  @override
  void initState() {
    super.initState();
    GetIt.I.getAsync<AuthState>().then((state) {
      _authState = state;
      _authState!.addListener(_checkAuthorization);
    });
  }

  _checkAuthorization() {
    setState(() {
      if (!_authState!.isLoggedIn()) {
        _appRouter.removeUntil((route) => false);
        _appRouter.push(LoginPageRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      title: 'Flutter Demo',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: getThemeData(ColorPaletteLight()),
      themeMode: ThemeMode.light, //Dark Mode disabled
      builder: (context, router) {
        Info(mediaQueryData: MediaQuery.of(context));
        return router!;
      },
    );
  }
}
