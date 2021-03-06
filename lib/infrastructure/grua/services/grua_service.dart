import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/grua/models/route_details.dart';
import 'package:flutter_base/infrastructure/grua/models/firebase_route_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/grua/models/evidence.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:location/location.dart';

import 'interfaces/i_grua_data_repository.dart';

@LazySingleton(as: IGruaService)
class GruaServiceImpl implements IGruaService {
  final IFirebaseService firebase;
  final IServerService server;
  final ICacheService cache;

  GruaServiceImpl({
    required this.firebase,
    required this.server,
    required this.cache,
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
    required LocationData? location,
  }) async {
    final _serviceOrfailure = await server.saveStatus(
      service: service,
      location: location,
    );
    if (_serviceOrfailure.isLeft()) {
      return _serviceOrfailure;
    }

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
  Future<Either<ErrorContent, FirebaseRouteModel>> getServiceRoute({
    required LatLng origin,
    required LatLng destination,
  }) {
    return firebase.getServiceRoute(
      origin: origin,
      destination: destination,
    );
  }

  @override
  Future<Either<ErrorContent, List<EvidenceType>>> getEvidenceTypes() async {
    final evidencesFromCacheOrFailure = await cache.getEvidenceTypes();
    final _evidences = evidencesFromCacheOrFailure.getOrElse(() => []);
    if (_evidences.isNotEmpty) {
      return evidencesFromCacheOrFailure;
    }
    final evidencesOrFailure = await server.getEvidenceTypes();
    if (evidencesOrFailure.isRight()) {
      final _evidencesFromServer = evidencesOrFailure.getOrElse(() => []);
      await cache.saveEvidenceTypes(_evidencesFromServer);
    }
    return evidencesOrFailure;
  }

  @override
  Future<Either<ErrorContent, Unit>> saveLocation({
    required Service service,
    required LatLng location,
  }) {
    return server.saveLocation(
      service: service,
      location: location,
    );
  }

  @override
  Future<Either<ErrorContent, Unit>> saveServiceSuggestedRoute({
    required Service service,
    required List<RouteDetails> routes,
  }) {
    return server.saveServiceSuggestedRoute(
      service: service,
      routes: routes,
    );
  }
}
