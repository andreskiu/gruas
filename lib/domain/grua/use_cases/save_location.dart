import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveLocationUseCase extends UseCase<Unit, SaveLocationUseCaseParams> {
  final IGruaService service;

  SaveLocationUseCase(this.service);

  @override
  Future<Either<ErrorContent, Unit>> call(
    SaveLocationUseCaseParams params,
  ) async {
    final _error = params.areValid();
    if (_error != null) {
      return Left(_error);
    }

    final _successOrFailure = await service.saveLocation(
      service: params.service,
      location: params.location,
    );

    return _successOrFailure;
  }
}

class SaveLocationUseCaseParams extends Equatable {
  final Service service;
  final LatLng location;

  SaveLocationUseCaseParams({
    required this.service,
    required this.location,
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
  List<Object> get props => [
        service,
        location,
      ];
}
