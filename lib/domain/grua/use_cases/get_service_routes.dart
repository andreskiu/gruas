import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/grua/models/route_details.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetServiceRouteUseCase
    extends UseCase<RouteDetails, GetServiceRouteUseCaseParams> {
  final IGruaService service;

  GetServiceRouteUseCase(this.service);

  @override
  Future<Either<ErrorContent, RouteDetails>> call(
    GetServiceRouteUseCaseParams params,
  ) async {
    final _error = params.areValid();
    if (_error != null) {
      return Left(_error);
    }

    final _firebaseRouteOrFailure = await service.getServiceRoute(
      origin: params.origin,
      destination: params.destination,
    );

    return _firebaseRouteOrFailure.fold(
      (failure) => Left(failure),
      (firebaseRoute) {
        double totalDistance = 0;
        double totalTime = 0;
        firebaseRoute.legs.forEach((leg) {
          totalDistance += leg.distance.value;
          totalTime += leg.duration.value;
        });
        final _route = RouteDetails(
          routeDetails: firebaseRoute,
          totalDistance: totalDistance,
          totalTime: totalTime,
        );

        return Right(_route);
      },
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
