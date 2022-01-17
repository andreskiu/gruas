import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/grua/models/route_details.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/use_cases/get_evidence_types.dart';
import 'package:flutter_base/domain/grua/use_cases/get_services.dart';
import 'package:flutter_base/domain/grua/use_cases/save_evidence.dart';
import 'package:flutter_base/domain/grua/use_cases/save_location.dart';
import 'package:flutter_base/domain/grua/use_cases/save_service.dart';
import 'package:flutter_base/domain/grua/models/evidence.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

@lazySingleton
class GruaServiceState extends ChangeNotifier {
  GruaServiceState._({
    required this.getServicesUseCase,
    required this.saveServicesUseCase,
    required this.authState,
    required this.saveEvidenceUseCase,
    required this.getEvidenceTypesUseCase,
    required this.saveLocationUseCase,
  });

  @factoryMethod
  static Future<GruaServiceState> init() async {
    final _authState = GetIt.I.get<AuthState>();
    final _getServicesUseCase = GetIt.I.get<GetServicesUseCase>();
    final _saveServicesUseCase = GetIt.I.get<SaveServicesUseCase>();
    final _saveEvidenceUseCase = GetIt.I.get<SaveEvidenceUseCase>();
    final _getEvidenceTypesUseCase = GetIt.I.get<GetEvidenceTypesUseCase>();
    final _saveLocationUseCase = GetIt.I.get<SaveLocationUseCase>();

    final _state = GruaServiceState._(
      getServicesUseCase: _getServicesUseCase,
      saveServicesUseCase: _saveServicesUseCase,
      authState: _authState,
      saveEvidenceUseCase: _saveEvidenceUseCase,
      getEvidenceTypesUseCase: _getEvidenceTypesUseCase,
      saveLocationUseCase: _saveLocationUseCase,
    );
    _state.updateRoutesStream = StreamController<bool>.broadcast();

    await _state.getServices();
    return _state;
  }

  final GetServicesUseCase getServicesUseCase;
  final SaveServicesUseCase saveServicesUseCase;
  final SaveEvidenceUseCase saveEvidenceUseCase;
  final GetEvidenceTypesUseCase getEvidenceTypesUseCase;
  final SaveLocationUseCase saveLocationUseCase;
  final AuthState authState;

  ErrorContent? error;
  Stream<List<Service>>? servicesStream;
  Service? servicesSelected;
  bool serviceUpdatedSuccesfully = false;
  bool evidenceUploaded = false;
  List<EvidenceType> evidenceTypes = [];

  LocationData? lastLocation;
  late StreamController<bool> updateRoutesStream;

  RouteDetails? routeToClient;
  RouteDetails? routeFromClientToDestination;

  setRoute(
    String routeId,
    RouteDetails route,
  ) {
    if (routeId == 'current_path') {
      routeToClient = route;
    } else {
      routeFromClientToDestination = route;
    }
    notifyListeners();
  }

  Future<void> getServices() async {
    final _params = GetServicesUseCaseParams(user: authState.loggedUser);
    final _streamOrFailure = await getServicesUseCase.call(_params);

    _streamOrFailure.fold(
      (fail) {
        error = fail;
      },
      (services) {
        servicesStream = services;
      },
    );
  }

  Future<List<EvidenceType>> getEvidenceTypes() async {
    final evidencesOrFailure = await getEvidenceTypesUseCase.call(NoParams());

    evidencesOrFailure.fold(
      (fail) => error = fail,
      (evidences) {
        evidenceTypes = evidences;
        error = null;
      },
    );
    notifyListeners();
    return evidenceTypes;
  }

  Future<bool> updateServiceStatus(ServiceStatus serviceStatus) async {
    LatLng? _currentLocation;
    final _routes = <RouteDetails>[];
    if (serviceStatus == ServiceStatus.accepted) {
      if (lastLocation != null) {
        _currentLocation = LatLng(
          lastLocation!.latitude!,
          lastLocation!.longitude!,
        );
      }
      if (routeToClient != null) {
        _routes.add(routeToClient!);
      }
      if (routeFromClientToDestination != null) {
        _routes.add(routeFromClientToDestination!);
      }
    }

    final _serviceCopy = servicesSelected?.copyWith(
      status: serviceStatus,
      username: authState.loggedUser.username,
      serviceAcceptedFromLocation: _currentLocation,
    );
    if (_serviceCopy == null) {
      error = ErrorContent.useCase("No service selected");
      return false;
    }

    final _params = SaveServicesUseCaseParams(
      service: _serviceCopy,
      routes: _routes,
    );
    final _serviceOrFailure = await saveServicesUseCase.call(_params);

    _serviceOrFailure.fold(
      (fail) {
        error = fail;
        serviceUpdatedSuccesfully = false;
      },
      (service) {
        serviceUpdatedSuccesfully = true;
        error = null;
        if (service.status == ServiceStatus.carPicked) {
          updateRoutesStream.sink.add(true);
        }
      },
    );
    notifyListeners();
    return _serviceOrFailure.isRight();
  }

  Future<bool> uploadEvidence(Evidence evidence) async {
    final _params = SaveEvidenceUseCaseParams(
      service: servicesSelected!,
      evidence: evidence,
    );
    final _serviceOrFailure = await saveEvidenceUseCase.call(_params);

    _serviceOrFailure.fold(
      (fail) {
        error = fail;
        evidenceUploaded = false;
      },
      (photoUrl) {
        evidenceUploaded = true;
        error = null;
      },
    );
    notifyListeners();
    return _serviceOrFailure.isRight();
  }

  Future<void> saveLocation({
    required LatLng location,
  }) async {
    final _params = SaveLocationUseCaseParams(
      service: servicesSelected!,
      location: location,
    );
    final _successOrFailure = await saveLocationUseCase.call(_params);
    // nothing to display to the user
  }
}
