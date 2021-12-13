import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetServiceRouteUseCase
    extends UseCase<PolylineResult, GetServiceRouteUseCaseParams> {
  final IGruaService service;

  GetServiceRouteUseCase(this.service);

  @override
  Future<Either<ErrorContent, PolylineResult>> call(
    GetServiceRouteUseCaseParams params,
  ) async {
    final _error = params.areValid();
    if (_error != null) {
      return Left(_error);
    }

    return service.getServiceRoute(
      origin: params.origin,
      destination: params.destination,
    );
  }
}

class GetServiceRouteUseCaseParams extends Equatable {
  final LatLng origin;
  final LatLng destination;

  GetServiceRouteUseCaseParams({
    required this.origin,
    required this.destination,
  });

  ErrorContent? areValid() {
    return null;
  }

  @override
  List<Object> get props => [
        origin,
        destination,
      ];
}
