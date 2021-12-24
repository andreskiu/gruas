import 'package:dio/dio.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/core/utils/image_helper.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/infrastructure/grua/models/evidence_type_server_model.dart';
import 'package:flutter_base/infrastructure/grua/services/interfaces/i_grua_data_repository.dart';
import 'package:flutter_base/domain/grua/models/evidence.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Environment(EnvironmentConfig.dev)
@Environment(EnvironmentConfig.qa)
@Environment(EnvironmentConfig.prod)
@LazySingleton(as: IServerService)
class GruaServerRepository extends IServerService {
  final Dio _dio = GetIt.I.get<Dio>();

  final _getEvidencesTypesPath = "attentionOnRoad/tipesEvidence";
  final _saveEvidencePath = "attentionOnRoad/saveEvidence";

  @override
  Future<Either<ErrorContent, List<EvidenceType>>> getEvidenceTypes() async {
    try {
      final _serverResponse = await _dio.get(
        _getEvidencesTypesPath,
      );

      final _typesWrapper = EvidenceTypeSWrapper.fromJson(_serverResponse.data);
      final List<EvidenceType> _types =
          _typesWrapper.listObject.map((model) => model.toEntity()).toList();
      return Right(_types);
    } on Exception catch (e) {
      return Left(ErrorContent.server("Error getting evidences types"));
    }
  }

  @override
  Future<Either<ErrorContent, String>> uploadPhoto({
    required Service service,
    required Evidence evidence,
  }) async {
    try {
      final _photoData = await ImageHelper.encodeJpg(evidence.photo);

      final _serverResponse = await _dio.post(_saveEvidencePath, data: {
        "file": _photoData,
        "data": {},
      });

      // final _typesWrapper = EvidenceTypeSWrapper.fromJson(_serverResponse.data);
      // final List<EvidenceType> _types =
      //     _typesWrapper.listObject.map((model) => model.toEntity()).toList();
      return Right("url");
    } on Exception catch (e) {
      return Left(ErrorContent.server("Error uploading evidence"));
    }
  }
}
