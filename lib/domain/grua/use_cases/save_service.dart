import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/core/utils/functions.dart';
import 'package:flutter_base/domain/grua/models/route_details.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:flutter_base/infrastructure/grua/models/firebase_route_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveServicesUseCase extends UseCase<Service, SaveServicesUseCaseParams> {
  final IGruaService service;

  SaveServicesUseCase(this.service);

  @override
  Future<Either<ErrorContent, Service>> call(
    SaveServicesUseCaseParams params,
  ) async {
    final _error = params.areValid();
    if (_error != null) {
      return Left(_error);
    }
    final _service = params.service;
    final _mustUpdateAcceptedTime = _service.status == ServiceStatus.accepted &&
        _service.serviceAcceptedTime == null;

    final _mustUpdateCarPickedTime =
        _service.status == ServiceStatus.carPicked &&
            _service.carPickedTime == null;

    final _mustUpdateFinishedTime = _service.status == ServiceStatus.finished &&
        _service.serviceFinishedTime == null;

    Service _serviceToSave = params.service.copyWith();

    if (_mustUpdateAcceptedTime) {
      _serviceToSave = _serviceToSave.copyWith(
        serviceAcceptedTime: DateTime.now(),
      );

      final _successOrFailure = await service.saveServiceSuggestedRoute(
        service: params.service,
        route: _mergeRoutes(
          routes: params.routes!,
        ),
      );
      if (_successOrFailure.isLeft()) {
        return Left(Functions.getError(_successOrFailure));
      }
    }

    if (_mustUpdateCarPickedTime) {
      _serviceToSave = _serviceToSave.copyWith(
        carPickedTime: DateTime.now(),
      );
    }

    if (_mustUpdateFinishedTime) {
      _serviceToSave = _serviceToSave.copyWith(
        serviceFinishedTime: DateTime.now(),
      );
    }

    final _servicesOrFailure = await service.saveService(
      service: _serviceToSave,
    );

    return _servicesOrFailure;
  }

  RouteDetails _mergeRoutes({
    required List<RouteDetails> routes,
  }) {
    List<LatLng> points = [];
    List<Leg> legs = [];
    double _totalDistance = 0;
    double _totalTime = 0;
    routes.forEach((route) {
      _totalDistance += route.totalDistance;
      _totalTime += route.totalTime;
      points.addAll(route.routeDetails.polylinesPoints.points);
      legs.addAll(route.routeDetails.legs);
    });

    return RouteDetails(
      routeDetails: FirebaseRouteModel(
        legs: legs,
        polylinesPoints: OverviewPolylines(
          points: points,
        ),
      ),
      totalDistance: _totalDistance,
      totalTime: _totalTime,
    );
  }
}

class SaveServicesUseCaseParams extends Equatable {
  final Service service;
  final List<RouteDetails>? routes;

  SaveServicesUseCaseParams({
    required this.service,
    this.routes,
  });

  ErrorContent? areValid() {
    String _msg = "";
    if (service.id.isEmpty) {
      _msg = "Service id is required";
    }
    if (service.username.isEmpty) {
      _msg = "Username is required";
    }

    if (_msg.isNotEmpty) {
      return ErrorContent.useCase(_msg);
    }

    if (service.status == ServiceStatus.accepted) {
      if (routes == null || routes!.isEmpty || routes!.length < 2) {
        return ErrorContent.useCase("Recommended route is missing");
      }
    }
    return null;
  }

  @override
  List<Object> get props => [service];
}
