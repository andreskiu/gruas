import 'package:dio/dio.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/auth/models/session_information.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_base/infrastructure/auth/services/i_auth_repository.dart';
import 'package:flutter_base/infrastructure/auth/services/i_auth_storage_repository.dart';
import 'package:flutter_base/infrastructure/grua/models/transformations_grua.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decode/jwt_decode.dart';

@Environment(EnvironmentConfig.dev)
@Environment(EnvironmentConfig.qa)
@Environment(EnvironmentConfig.prod)
@LazySingleton(as: IAuthDataRepository)
class DemoRepository extends IAuthDataRepository {
  final Dio _dio = GetIt.I.get<Dio>();
  final _pref = GetIt.I.get<IAuthStorageRepository>();

  final _loginPath = "oauth/token";
  final _getServiceTypePath = "atvUser/typeServiceVehicle";
  @override
  Future<Either<ErrorContent, User?>> getUserLoggedIn({
    required String sessionId,
  }) async {
    final _sessionOrFailure = await _pref.getSessionInformation();

    final _session = _sessionOrFailure.getOrElse(
      () => SessionInformation.empty(),
    );

    final _expiryTokenDate = Jwt.getExpiryDate(_session.sessionId);

    if (_expiryTokenDate == null || _expiryTokenDate.isBefore(DateTime.now())) {
      return Left(ErrorContent.server("Session Expired"));
    }

    Map<String, dynamic> _payload = Jwt.parseJwt(_session.sessionId);

    final _username = _payload['user_name'];

    final _usernameTypeOrFailure = await getUserServiceType(
      username: _username,
    );

    if (_usernameTypeOrFailure.isLeft()) {
      return Left(ErrorContent.server("Session expirada"));
    }

    final _user = User(
      id: _payload['client_id'],
      username: _username,
      session: SessionInformation(
        sessionId: _session.sessionId,
        expireSession: _expiryTokenDate,
      ),
      name: "name",
      serviceOffered: _usernameTypeOrFailure.getOrElse(() => ServiceType.grua),
    );
    return Right(_user);
  }

  @override
  Future<Either<ErrorContent, User>> login({
    required String username,
    required String password,
  }) async {
    try {
      final _serverResponse = await _dio.post(
        _loginPath,
        queryParameters: {
          'username': username,
          'password': password,
          'grant_type': "password"
        },
      );

      if (_serverResponse.statusCode != 200) {
        return Left(ErrorContent.server(
          _serverResponse.statusMessage!,
        ));
      }
      final _expireSession = DateTime.now().add(
        Duration(seconds: _serverResponse.data['expires_in'] ?? 900),
      );
      final _token = _serverResponse.data['access_token'];

      Map<String, dynamic> _payload = Jwt.parseJwt(_token);

      final _user = User(
        id: _payload['client_id'],
        username: username,
        session: SessionInformation(
          sessionId: _token,
          expireSession: _expireSession,
        ),
        name: "name",
        serviceOffered: ServiceType.grua,
      );
      return Right(_user);
    } catch (e) {
      return Left(ErrorContent.server("Login error"));
    }
  }

  @override
  Future<Either<ErrorContent, ServiceType>> getUserServiceType({
    required String username,
  }) async {
    try {
      final _getTyperResponse = await _dio.get(
        _getServiceTypePath,
        queryParameters: {
          'username': username,
        },
      );
      if (_getTyperResponse.statusCode != 200) {
        return Left(ErrorContent.server(
          _getTyperResponse.statusMessage ?? 'Please try again',
        ));
      }

      if (_getTyperResponse.data['states_code'] != 200) {
        return Left(ErrorContent.server(
          _getTyperResponse.data['message']!,
        ));
      }

      return Right(TransformationsGrua.intToServiceType(
        _getTyperResponse.data['data']['id'],
      ));
    } catch (e) {
      return Left(ErrorContent.server("Login error"));
    }
  }

  @override
  Future<Either<ErrorContent, Unit>> logout() async {
    return Right(unit);
  }
}
