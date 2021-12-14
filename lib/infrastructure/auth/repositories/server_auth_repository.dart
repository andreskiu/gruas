import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/auth/models/session_information.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_base/infrastructure/auth/services/i_auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Environment(EnvironmentConfig.dev)
@Environment(EnvironmentConfig.qa)
@Environment(EnvironmentConfig.prod)
@LazySingleton(as: IAuthDataRepository)
class DemoRepository extends IAuthDataRepository {
  final Dio _dio = GetIt.I.get<Dio>();

  final _loginPath = "oauth/token";
  @override
  Future<Either<ErrorContent, User?>> getUserLoggedIn({
    required String sessionId,
  }) async {
    // TODO: implement getUserLoggedIn
    return Right(null);
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorContent, User>> login({
    required String username,
    required String password,
  }) async {
    try {
      String _basicAuth =
          'Basic ' + base64Encode(utf8.encode('rigelWS:rigelWS2021'));
      final _serverResponse = await _dio.post(
        _loginPath,
        options: Options(
          headers: {
            "Authorization": _basicAuth,
          },
        ),
        queryParameters: {
          'username': username,
          'password': password,
          'grant_type': "password"
        },
      );
      final _expireSession = DateTime.now().add(
        Duration(seconds: _serverResponse.data['expires_in'] ?? 900),
      );
      final _user = User(
        id: "22",
        username: username,
        session: SessionInformation(
          sessionId: _serverResponse.data['access_token'],
          expireSession: _expireSession,
        ),
        name: "name",
        serviceOffered: ServiceType.grua,
      );
      return Right(_user);
    } on Exception catch (e) {
      return Left(ErrorContent.server("Login error"));
    }
  }

  @override
  Future<Either<ErrorContent, Unit>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}

// @LazySingleton(as: IDataRepository, env: [
//   EnvironmentConfig.dev,
//   EnvironmentConfig.test,
//   EnvironmentConfig.prod,
// ])
// class ReportRestRepository
//     with DioErrorManagerMixin
//     implements IDataRepository {
//   ReportRestRepository(this._api);
//   final Api _api;

//   @override
//   Future<Either<ServerFailure, List<DailyTXbyUserModel>>> getDailyTXbyUser(
//       {@required GetDailyTXbyUserDataModel dataModel}) async {
//     try {
//       final resp = await _api.client.get(
//         '/transactionsbyuser',
//         queryParameters:
//             GetDailyTXbyUserReqModel.fromDataModel(dataModel).toMap(),
//       );
//       List<dynamic> _listadoDatos = resp.data;

//       final respModel = _listadoDatos
//           .map((t) =>
//               GetDailyTXbyUserRespModel.fromMap(t).toDailyTXbyUserModel())
//           .toList();
//       return Right(respModel);
//     } on DioError catch (e) {
//       return Left(manageDioError(e));
//     } on FormatException {
//       return Left(ServerFailure.formatFailure());
//     } catch (e) {
//       return Left(ServerFailure.generalError());
//     }
//   }
