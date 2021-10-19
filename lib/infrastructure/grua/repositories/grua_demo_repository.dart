import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/infrastructure/grua/services/interfaces/i_grua_data_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';

@Environment(EnvironmentConfig.demo)
@LazySingleton(
  as: IGruaDataRepository,
)
class GruaDemoRepositoryImpl implements IGruaDataRepository, Disposable {
  final _services = [
    Service(
      type: ServiceType.grua,
      clientName: "Pablo Gutierrez",
      clientLocation: LatLng(10.391389, -75.488570),
      detinationLocation: LatLng(10.398359, -75.489476),
      carModel: "Nissan Versa",
      requestTime: DateTime.now().subtract(Duration(minutes: 30)),
      userId: "3",
    ),
    Service(
      type: ServiceType.carroTaller,
      clientName: "Gabriel Figueroa",
      clientLocation: LatLng(10.395399, -75.486776),
      detinationLocation: LatLng(10.392399, -75.488976),
      carModel: "Fiat Cronnos",
      requestTime: DateTime.now().subtract(Duration(minutes: 20)),
      userId: "3",
    ),
    Service(
      type: ServiceType.grua,
      clientName: "Gabriel Figueroa",
      clientLocation: LatLng(10.396029, -75.490076),
      detinationLocation: LatLng(10.391399, -75.480276),
      carModel: "Chevrolet Onix",
      requestTime: DateTime.now().subtract(Duration(minutes: 15)),
      userId: "3",
    ),
    Service(
      type: ServiceType.grua,
      clientName: "Raul Lopez",
      clientLocation: LatLng(10.390859, -75.489070),
      detinationLocation: LatLng(10.399659, -75.490136),
      carModel: "Toyota Yaris",
      requestTime: DateTime.now().subtract(Duration(minutes: 30)),
      userId: "3",
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
}
