import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/styles/light_theme.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/routes/guards/auth_guards.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'application/auth/auth_state.dart';
import 'config/injectable/injectable.dart';
import 'presentation/core/routes/app_router.gr.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ES');
  await initConfig();
  runApp(MyApp());
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
      theme: getThemeData(ColorPaletteLight()),
      themeMode: ThemeMode.light, //Dark Mode disabled
      builder: (context, router) {
        Info(mediaQueryData: MediaQuery.of(context));
        return router!;
      },
    );
  }
}
