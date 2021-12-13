import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:flutter_base/infrastructure/grua/models/evidence.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:flutter_polyline_points/src/utils/polyline_result.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
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

  @override
  Future<Either<ErrorContent, Service>> saveService({
    required Service service,
  }) {
    return repository.saveService(service: service);
  }

  @override
  Future<Either<ErrorContent, String>> uploadPhoto({
    required Service service,
    required Evidence evidence,
  }) {
    return repository.uploadPhoto(
      service: service,
      evidence: evidence,
    );
  }

  @override
  Future<Either<ErrorContent, PolylineResult>> getServiceRoute(
      {required LatLng origin, required LatLng destination}) {
    return repository.getServiceRoute(
      origin: origin,
      destination: destination,
    );
  }
}
