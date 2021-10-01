import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/auth/models/session_information.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/infrastructure/auth/services/i_auth_repository.dart';

@Environment(EnvironmentConfig.demo)
@LazySingleton(as: IAuthDataRepository)
class DemoRepository extends IAuthDataRepository {
  final _registeredUsers = [
    User(
      id: "1",
      name: "Andrés",
      session: SessionInformation(
        sessionId: "12555g33455sds",
        expireSession: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      username: 'andreskiu@hotmail.com',
      serviceOffered: ServiceType.grua,
    ),
    User(
      id: "2",
      name: "Andrés",
      session: SessionInformation(
        sessionId: "45435grwrgf4",
        expireSession: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      username: 'andres_raya1990@hotmail.com',
      serviceOffered: ServiceType.grua,
    ),
    User(
      id: "3",
      name: "Pablo",
      session: SessionInformation(
        sessionId: "dfdfe4346t3b6g34645",
        expireSession: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      username: 'a@a.com',
      serviceOffered: ServiceType.grua,
    ),
    User(
      id: "4",
      name: "Franco",
      session: SessionInformation(
        sessionId: "fgfdy57ghfghyru",
        expireSession: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      username: 'aaaaaa@aaaaaa.com',
      serviceOffered: ServiceType.motoCarro,
    ),
    User(
      id: "5",
      name: "Gabriel",
      session: SessionInformation(
        sessionId: "ggu6urtuy6488gfhf",
        expireSession: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      username: 'andreskiu',
      serviceOffered: ServiceType.grua,
    ),
    User(
        id: "6",
        name: "Matías",
        session: SessionInformation(
          sessionId: "hgh46u6u65u66yu6u6u",
          expireSession: DateTime.fromMillisecondsSinceEpoch(0),
        ),
        username: 'aaaaaa',
        serviceOffered: ServiceType.motoCarro),
    User(
      id: "7",
      name: "Benjamín",
      session: SessionInformation(
        sessionId: "fgfdgd321g21f5d4g5d",
        expireSession: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      username: 'kiu',
      serviceOffered: ServiceType.motoCarro,
    ),
  ];

  final _validPasswords = [
    "aaaaaa",
    "a",
    "1",
    "111111",
    "andreskiu",
    "1234",
    "12345",
    "123456",
  ];
  @override
  Future<Either<ErrorContent, User>> login({
    required String username,
    required String password,
  }) async {
    try {
      final _user = _registeredUsers.firstWhere(
        (user) => user.username == username,
      );
      // check if password "is valid"
      _validPasswords.firstWhere((psw) => psw == password);

      return Right(_user);
    } catch (_) {
      return Left(ErrorContent.server("User Not Found"));
    }
  }

  @override
  Future<Either<ErrorContent, User?>> getUserLoggedIn({
    required String sessionId,
  }) async {
    try {
      final _user = _registeredUsers.firstWhere(
        (user) => user.session?.sessionId == sessionId,
      );
      return Right(_user);
    } catch (e) {
      return Left(ErrorContent.server("User Not Found"));
    }
  }

  @override
  Future<Either<ErrorContent, Unit>> logout() async {
    return Right(unit);
  }
}
