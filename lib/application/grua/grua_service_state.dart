import 'package:flutter/foundation.dart';
import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/use_cases/get_services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GruaServiceState extends ChangeNotifier {
  GruaServiceState._({
    required this.getServicesUseCase,
    required this.authState,
  });

  @factoryMethod
  static Future<GruaServiceState> init() async {
    final _authState = GetIt.I.get<AuthState>();
    final _getServicesUseCase = GetIt.I.get<GetServicesUseCase>();

    final _state = GruaServiceState._(
      getServicesUseCase: _getServicesUseCase,
      authState: _authState,
    );
    await _state.getServices();
    return _state;
  }

  final GetServicesUseCase getServicesUseCase;
  final AuthState authState;
  ErrorContent? error;
  Stream<List<Service>>? servicesStream;

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
}
