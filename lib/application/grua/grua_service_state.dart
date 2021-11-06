import 'package:flutter/foundation.dart';
import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/use_cases/get_services.dart';
import 'package:flutter_base/domain/grua/use_cases/save_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GruaServiceState extends ChangeNotifier {
  GruaServiceState._({
    required this.getServicesUseCase,
    required this.saveServicesUseCase,
    required this.authState,
  });

  @factoryMethod
  static Future<GruaServiceState> init() async {
    final _authState = GetIt.I.get<AuthState>();
    final _getServicesUseCase = GetIt.I.get<GetServicesUseCase>();
    final _saveServicesUseCase = GetIt.I.get<SaveServicesUseCase>();

    final _state = GruaServiceState._(
      getServicesUseCase: _getServicesUseCase,
      saveServicesUseCase: _saveServicesUseCase,
      authState: _authState,
    );
    await _state.getServices();
    return _state;
  }

  final GetServicesUseCase getServicesUseCase;
  final SaveServicesUseCase saveServicesUseCase;
  final AuthState authState;
  ErrorContent? error;
  Stream<List<Service>>? servicesStream;
  Service? servicesSelected;

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
      },
      (service) {
        // servicesStream = service;
      },
    );
    notifyListeners();
    return _serviceOrFailure.isRight();
  }
}
