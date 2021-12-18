import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetEvidenceTypesUseCase extends UseCase<List<EvidenceType>, NoParams> {
  final IGruaService service;

  GetEvidenceTypesUseCase(this.service);

  @override
  Future<Either<ErrorContent, List<EvidenceType>>> call(
    NoParams params,
  ) async {
    final _evidencesOrFailure = await service.getEvidenceTypes();

    return _evidencesOrFailure;
  }
}
