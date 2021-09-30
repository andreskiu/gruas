import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/auth/models/session_information.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/infrastructure/core/interfaces/i_local_storage_repository.dart';

abstract class IAuthStorageRepository implements ILocalStorageRepository {
  Future<Either<ErrorContent, Unit>> storeSessionInformation({
    required SessionInformation sessionInformation,
  });

  Future<Either<ErrorContent, SessionInformation>> getSessionInformation();
  Future<Either<ErrorContent, Unit>> storeUsername({
    required String username,
  });

  Future<Either<ErrorContent, String>> getUsername();
}
