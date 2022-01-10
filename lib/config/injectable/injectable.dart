import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_base/domain/auth/models/session_information.dart';
import 'package:flutter_base/infrastructure/auth/services/i_auth_storage_repository.dart';
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
  Dio dio() {
    final _dio = Dio(
      BaseOptions(
        baseUrl: GetIt.I.get<EnvironmentConfig>().baseUrl,
        contentType: Headers.jsonContentType,
        connectTimeout: 10000, //10 seconds
      ),
    );
    final _appInterceptor = GetIt.I.get<InterceptorsWrapper>();
    _dio.interceptors.add(_appInterceptor);
    return _dio;
  }

  @preResolve // if you need to pre resolve the value (for future)
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

@Injectable(
    as: InterceptorsWrapper,
    env: [EnvironmentConfig.dev, EnvironmentConfig.qa, EnvironmentConfig.prod])
class AppInterceptorsWrapper extends InterceptorsWrapper {
  final IAuthStorageRepository authRepo;
  AppInterceptorsWrapper({
    required this.authRepo,
  }) : super(
          onRequest: (options, handler) async {
            late String _token;
            // options.path ==
            // if (_sessionInformation.sessionId.isEmpty ) {
            if (options.path == "oauth/token") {
              _token = 'Basic ' +
                  base64Encode(
                    utf8.encode('atvWS:atvWS2021'),
                  );
            } else {
              final _sessionInformation =
                  (await authRepo.getSessionInformation()).getOrElse(
                () => SessionInformation.empty(),
              );
              _token = 'Bearer ' + _sessionInformation.sessionId;
            }
            options.headers[HttpHeaders.authorizationHeader] = _token;
            return handler.next(options);
            // return options;
          },
          // onError: ( error, handler) async {

          //   DioError()
          //   if (error.type == DioErrorType.CONNECT_TIMEOUT ||
          //       error.type == DioErrorType.RECEIVE_TIMEOUT) {
          //     return ServerFailure.connectionError();
          //   }

          //   if (error.type == DioErrorType.RESPONSE) {
          //     switch (error.response.statusCode) {
          //       case 400:
          //         return ServerFailure.requestError(
          //           respModel: ServerResponseModel.fromMap(error.response.data),
          //         );
          //         break;
          //       case 401:
          //         return ServerFailure.unauthorizedUser();
          //         break;
          //       case 403:
          //         final userToken =
          //             (await authRepo.getToken()).getOrElse(() => null);
          //         if (userToken != null && error.response != null) {
          //           final _authState = GetIt.I.get<AuthState>();
          //           _authState.unAuthorizedAccess();
          //         }
          //         return ServerFailure.unauthorizedUser();
          //         break;
          //       case 404:
          //         return ServerFailure.notFound();
          //         break;
          //       default:
          //         return ServerFailure.generalError();
          //     }
          //   }
          //   return ServerFailure.generalError();
          // },
        );
}
