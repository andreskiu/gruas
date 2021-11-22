import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:flutter_base/infrastructure/grua/models/evidence.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveEvidenceUseCase extends UseCase<String, SaveEvidenceUseCaseParams> {
  final IGruaService service;

  SaveEvidenceUseCase(this.service);

  @override
  Future<Either<ErrorContent, String>> call(
    SaveEvidenceUseCaseParams params,
  ) async {
    final _error = params.areValid();
    if (_error != null) {
      return Left(_error);
    }

    final _urlOrFailure = await service.uploadPhoto(
      evidence: params.evidence,
      service: params.service,
    );

    return _urlOrFailure;
  }
}

class SaveEvidenceUseCaseParams extends Equatable {
  final Service service;
  final Evidence evidence;

  SaveEvidenceUseCaseParams({
    required this.service,
    required this.evidence,
  });

  ErrorContent? areValid() {
    String _msg = "";
    if (service.id.isEmpty) {
      _msg = "Service id is required";
    }

    if (_msg.isNotEmpty) {
      return ErrorContent.useCase(_msg);
    }
    return null;
  }

  @override
  List<Object> get props => [service];
}
