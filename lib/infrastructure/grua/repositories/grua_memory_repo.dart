import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/infrastructure/grua/models/evidence_type_server_model.dart';
import 'package:flutter_base/infrastructure/grua/services/interfaces/i_grua_data_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Environment(EnvironmentConfig.dev)
@Environment(EnvironmentConfig.qa)
@Environment(EnvironmentConfig.prod)
@LazySingleton(as: ICacheService)
class GruaMemoryRepository extends ICacheService {
  final _pref = GetIt.I.get<SharedPreferences>();
  final evidenceTypesKey = 'evidences';
  List<EvidenceType> _evidences = [];
  @override
  Future<Either<ErrorContent, List<EvidenceType>>> getEvidenceTypes() async {
    return Right(_evidences);
    // try {
    //   final _evidenceListString = _pref.getStringList(evidenceTypesKey);
    //   if (_evidenceListString == null) {
    //     return Right([]);
    //   }
    //   final _evidencesServerModel = _evidenceListString
    //       .map((str) =>
    //           EvidenceTypeServerModel.fromJson(json.decode(str)).toEntity())
    //       .toList();
    //   return Right(_evidencesServerModel);
    // } on Exception catch (e) {
    //   return Left(ErrorContent.server('Fail to get evicende types'));
    // }
  }

  @override
  Future<Either<ErrorContent, Unit>> saveEvidenceTypes(
      List<EvidenceType> evidences) async {
    _evidences = evidences;
    return Right(unit);
    // try {
    //   final _list =
    //       evidences.map((ev) => EvidenceTypeServerModel.fromEntity(ev));
    //   final _listString = _list.map((e) => json.encode(e.toJson())).toList();

    //   await _pref.setStringList(evidenceTypesKey, _listString);
    //   return Right(unit);
    // } on Exception catch (e) {
    //   return Left(ErrorContent.server('Fail to store evicende types'));
    // }
  }
}
