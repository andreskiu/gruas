import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/auth/services/auth_service.dart';
import 'package:flutter_base/domain/core/error_content.dart';

import 'interfaces/i_grua_data_repository.dart';

@LazySingleton(as: IGruaService)
class GruaServiceImpl implements IGruaService {
  final IGruaDataRepository repository;

  GruaServiceImpl({
    required this.repository,
  });

  @override
  Future<Either<ErrorContent, Stream<List<Service>>>> getServices({
    required User user,
  }) {
    return repository.getServices(user: user);
  }
}
