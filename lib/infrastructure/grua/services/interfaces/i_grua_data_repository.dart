import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/grua/models/service.dart';

abstract class IGruaDataRepository {
  Future<Either<ErrorContent, Stream<List<Service>>>> getServices({
    required User user,
  });

  Future<Either<ErrorContent, Service>> saveService({
    required Service service,
  });
}
