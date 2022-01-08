import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<ErrorContent, PolylineResult>> getServiceRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      const _androidAPIKEY = "AIzaSyCW4JEtCHKHgITyJ7WJfvvgMKxi4WqJPqc";
      //TODO: borra todo esto y sacalo de aqui
      // https://github.com/Dammyololade/flutter_polyline_points/blob/master/lib/src/network_util.dart
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
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
      if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
        return Left(ErrorContent.server(result.errorMessage!));
      }
      return Right(result);
    } on Exception catch (e) {
      print('Fail to calculate route');
      return Left(ErrorContent.server('Fail to calculate route'));
    }
  }
}
