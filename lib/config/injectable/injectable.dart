import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_base/config/environments/environment_config.dart';

import 'injectable.config.dart';

final GetIt getIt = GetIt.instance;
final EnvironmentConfig? envConfig = getIt<EnvironmentConfig>();
@injectableInit
Future<void> initConfig() async {
  await manualInitializations();
  await $initGetIt(getIt, environment: EnvironmentConfig.env);
}

Future<void> manualInitializations() async {
  await Firebase.initializeApp();
}

// third partys libraries
@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio() => Dio(
        BaseOptions(
          baseUrl: GetIt.I.get<EnvironmentConfig>().baseUrl,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

  @preResolve // if you need to pre resolve the value (for future)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
