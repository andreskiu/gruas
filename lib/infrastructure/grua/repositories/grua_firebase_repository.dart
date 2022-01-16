import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_base/infrastructure/grua/models/firebase_route_model.dart';
import 'package:flutter_base/infrastructure/grua/models/novedad_atv.dart';
import 'package:flutter_base/infrastructure/grua/models/transformations_grua.dart';
import 'dart:async';

import 'package:flutter_base/infrastructure/grua/services/interfaces/i_grua_data_repository.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@Environment(EnvironmentConfig.dev)
@Environment(EnvironmentConfig.qa)
@Environment(EnvironmentConfig.prod)
@LazySingleton(
  as: IFirebaseService,
)
class GruaDemoRepositoryImpl implements IFirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _servicesPath = "novedad_atv";

  final Dio _dioForMaps = Dio(
    BaseOptions(
      baseUrl: 'https://maps.googleapis.com/',
    ),
  );
  @override
  Future<Either<ErrorContent, Stream<List<Service>>>> getServices({
    required User user,
  }) async {
    final _serviceStream = _firestore
        .collection(_servicesPath)
        .where(
          "idAtvTipoServicio",
          isEqualTo: TransformationsGrua.serviceTypeToInt(user.serviceOffered),
        )
        .where(
      "username",
      whereIn: [
        "",
        user.username,
      ],
    ).snapshots();
    final _serviceMapped = _serviceStream.map((query) => query.docs
        .map(
          (doc) => NovedadAtv.fromJson(
            doc.data(),
          ).toService(),
        )
        .toList());

    return Right(_serviceMapped);
  }

  @override
  Future<Either<ErrorContent, Service>> saveService({
    required Service service,
  }) async {
    try {
      await _firestore
          .collection(_servicesPath)
          .doc(service.id)
          .set(NovedadAtv.fromService(service).toJson());
      return Right(service);
    } catch (e) {
      print(e);
      return Left(ErrorContent.server("Fail to save service"));
    }
  }

  @override
  Future<Either<ErrorContent, FirebaseRouteModel>> getServiceRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      const _androidAPIKEY = "AIzaSyCW4JEtCHKHgITyJ7WJfvvgMKxi4WqJPqc";
      final routeOrFailure = await getRouteBetweenCoordinates(
        _androidAPIKEY,
        PointLatLng(
          origin.latitude,
          origin.longitude,
        ),
        PointLatLng(
          destination.latitude,
          destination.longitude,
        ),
      );

      return routeOrFailure;
    } on Exception catch (e) {
      print('Fail to calculate route');
      return Left(ErrorContent.server('Fail to calculate route'));
    }
  }

  Future<Either<ErrorContent, FirebaseRouteModel>> getRouteBetweenCoordinates(
    String googleApiKey,
    PointLatLng origin,
    PointLatLng destination, {
    TravelMode travelMode = TravelMode.driving,
    List<PolylineWayPoint> wayPoints = const [],
    bool avoidHighways = false,
    bool avoidTolls = false,
    bool avoidFerries = true,
    bool optimizeWaypoints = false,
  }) async {
    String mode = travelMode.toString().replaceAll('TravelMode.', '');

    var params = {
      "origin": "${origin.latitude},${origin.longitude}",
      "destination": "${destination.latitude},${destination.longitude}",
      "mode": mode,
      "avoidHighways": "$avoidHighways",
      "avoidFerries": "$avoidFerries",
      "avoidTolls": "$avoidTolls",
      "key": googleApiKey
    };
    if (wayPoints.isNotEmpty) {
      List wayPointsArray = [];
      wayPoints.forEach((point) => wayPointsArray.add(point.location));
      String wayPointsString = wayPointsArray.join('|');
      if (optimizeWaypoints) {
        wayPointsString = 'optimize:true|$wayPointsString';
      }
      params.addAll({"waypoints": wayPointsString});
    }

    try {
      var response = await _dioForMaps.get(
        "maps/api/directions/json",
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final result = FirebaseRouteModel.fromJson(response.data["routes"][0]);
        return Right(result);
      } else {
        return Left(ErrorContent.server('Fail to calculate route'));
      }
    } on Exception catch (e) {
      return Left(ErrorContent.server('Fail to calculate route'));
    }
  }
}
