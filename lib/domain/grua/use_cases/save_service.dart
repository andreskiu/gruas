import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
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

    final _servicesOrFailure = await service.saveService(
      service: params.service,
    );

    return _servicesOrFailure;
  }
}

class SaveServicesUseCaseParams extends Equatable {
  final Service service;

  SaveServicesUseCaseParams({
    required this.service,
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
    return null;
  }

  @override
  List<Object> get props => [service];
}
