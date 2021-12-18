import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/models/evidence.dart';
import 'package:flutter_base/infrastructure/grua/services/interfaces/i_grua_data_repository.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';

@Environment(EnvironmentConfig.demo)
@LazySingleton(
  as: IFirebaseService,
)
class GruaDemoRepositoryImpl implements IFirebaseService, Disposable {
  final _services = [
    Service(
      id: "1234",
      type: ServiceType.grua,
      clientName: "Pablo Gutierrez",
      clientLocation: LatLng(10.391389, -75.488570),
      detinationLocation: LatLng(10.398359, -75.489476),
      carModel: "Nissan Versa",
      requestTime: DateTime.now().subtract(Duration(minutes: 30)),
      username: "3",
    ),
    Service(
      id: "5678",
      type: ServiceType.carroTaller,
      clientName: "Gabriel Figueroa",
      clientLocation: LatLng(10.395399, -75.486776),
      detinationLocation: LatLng(10.392399, -75.488976),
      carModel: "Fiat Cronnos",
      requestTime: DateTime.now().subtract(Duration(minutes: 20)),
      username: "3",
    ),
    Service(
      id: "9012",
      type: ServiceType.grua,
      clientName: "Gabriel Figueroa",
      clientLocation: LatLng(10.396029, -75.490076),
      detinationLocation: LatLng(10.391399, -75.480276),
      carModel: "Chevrolet Onix",
      requestTime: DateTime.now().subtract(Duration(minutes: 15)),
      username: "3",
    ),
    Service(
      id: "3456",
      type: ServiceType.grua,
      clientName: "Raul Lopez",
      clientLocation: LatLng(10.390859, -75.489070),
      detinationLocation: LatLng(10.399659, -75.490136),
      carModel: "Toyota Yaris",
      requestTime: DateTime.now().subtract(Duration(minutes: 30)),
      username: "3",
    ),
  ];

  final _streamController = StreamController<List<Service>>();

  @override
  Future<Either<ErrorContent, Stream<List<Service>>>> getServices({
    required User user,
  }) async {
    _streamController.onListen = () {
      _streamController.add(_services);
    };
    return Right(_streamController.stream);
  }

  @override
  FutureOr onDispose() {
    _streamController.sink.close();
    _streamController.close();
  }

  @override
  Future<Either<ErrorContent, Service>> saveService({
    required Service service,
  }) async {
    final _serviceIndex = _services.indexWhere(
      (s) => s.id == service.id,
    );
    if (_serviceIndex != -1) {
      return Left(ErrorContent.server("Service not found"));
    }
    final _servicesCopy = _services[_serviceIndex].copyWith(
      status: service.status,
      username: service.username,
    );
    _services[_serviceIndex] = _servicesCopy;
    _streamController.sink.add(_services);
    return Right(_servicesCopy);
  }

  @override
  Future<Either<ErrorContent, String>> uploadPhoto({
    required Service service,
    required Evidence evidence,
  }) async {
    await Future.delayed(Duration(seconds: 5));
    return Right("DEMO URLL");
  }

  @override
  Future<Either<ErrorContent, PolylineResult>> getServiceRoute({
    required LatLng origin,
    required LatLng destination,
  }) {
    // TODO: implement getServiceRoute
    throw UnimplementedError();
  }
}
