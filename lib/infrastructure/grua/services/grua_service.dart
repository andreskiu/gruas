import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/grua/models/evidence.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';

import 'interfaces/i_grua_data_repository.dart';

@LazySingleton(as: IGruaService)
class GruaServiceImpl implements IGruaService {
  final IFirebaseService firebase;
  final IServerService server;

  GruaServiceImpl({
    required this.firebase,
    required this.server,
  });

  @override
  Future<Either<ErrorContent, Stream<List<Service>>>> getServices({
    required User user,
  }) {
    return firebase.getServices(user: user);
  }

  @override
  Future<Either<ErrorContent, Service>> saveService({
    required Service service,
  }) {
    return firebase.saveService(service: service);
  }

  @override
  Future<Either<ErrorContent, String>> uploadPhoto({
    required Service service,
    required Evidence evidence,
  }) {
    return server.uploadPhoto(
      service: service,
      evidence: evidence,
    );
  }

  @override
  Future<Either<ErrorContent, PolylineResult>> getServiceRoute({
    required LatLng origin,
    required LatLng destination,
  }) {
    return firebase.getServiceRoute(
      origin: origin,
      destination: destination,
    );
  }

  @override
  Future<Either<ErrorContent, List<EvidenceType>>> getEvidenceTypes() {
    return server.getEvidenceTypes();
  }
}
