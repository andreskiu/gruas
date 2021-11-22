import 'package:flutter/foundation.dart';
import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/use_cases/get_services.dart';
import 'package:flutter_base/domain/grua/use_cases/save_evidence.dart';
import 'package:flutter_base/domain/grua/use_cases/save_service.dart';
import 'package:flutter_base/infrastructure/grua/models/evidence.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GruaServiceState extends ChangeNotifier {
  GruaServiceState._({
    required this.getServicesUseCase,
    required this.saveServicesUseCase,
    required this.authState,
    required this.saveEvidenceUseCase,
  });

  @factoryMethod
  static Future<GruaServiceState> init() async {
    final _authState = GetIt.I.get<AuthState>();
    final _getServicesUseCase = GetIt.I.get<GetServicesUseCase>();
    final _saveServicesUseCase = GetIt.I.get<SaveServicesUseCase>();
    final _saveEvidenceUseCase = GetIt.I.get<SaveEvidenceUseCase>();

    final _state = GruaServiceState._(
      getServicesUseCase: _getServicesUseCase,
      saveServicesUseCase: _saveServicesUseCase,
      authState: _authState,
      saveEvidenceUseCase: _saveEvidenceUseCase,
    );
    await _state.getServices();
    return _state;
  }

  final GetServicesUseCase getServicesUseCase;
  final SaveServicesUseCase saveServicesUseCase;
  final SaveEvidenceUseCase saveEvidenceUseCase;
  final AuthState authState;

  ErrorContent? error;
  Stream<List<Service>>? servicesStream;
  Service? servicesSelected;
  bool serviceUpdatedSuccesfully = false;
  bool evidenceUploaded = false;

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

  Future<bool> updateServiceStatus(ServiceStatus serviceStatus) async {
    final _serviceCopy = servicesSelected?.copyWith(
      status: serviceStatus,
      username: authState.loggedUser.username,
    );
    if (_serviceCopy == null) {
      error = ErrorContent.useCase("No service selected");
      return false;
    }
    final _params = SaveServicesUseCaseParams(service: _serviceCopy);
    final _serviceOrFailure = await saveServicesUseCase.call(_params);

    _serviceOrFailure.fold(
      (fail) {
        error = fail;
        serviceUpdatedSuccesfully = false;
      },
      (service) {
        serviceUpdatedSuccesfully = true;
        error = null;
      },
    );
    notifyListeners();
    return _serviceOrFailure.isRight();
  }

  Future<bool> uploadEvidence(Evidence evidence) async {
    final _params = SaveEvidenceUseCaseParams(
        service: servicesSelected!, evidence: evidence);
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
}
