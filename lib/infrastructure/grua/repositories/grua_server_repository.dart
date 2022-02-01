import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_base/config/environments/environment_config.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/core/utils/image_helper.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/grua/models/route_details.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/infrastructure/grua/models/evidence_type_server_model.dart';
import 'package:flutter_base/infrastructure/grua/models/transformations_grua.dart';
import 'package:flutter_base/infrastructure/grua/services/interfaces/i_grua_data_repository.dart';
import 'package:flutter_base/domain/grua/models/evidence.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@Environment(EnvironmentConfig.dev)
@Environment(EnvironmentConfig.qa)
@Environment(EnvironmentConfig.prod)
@LazySingleton(as: IServerService)
class GruaServerRepository extends IServerService {
  final Dio _dio = GetIt.I.get<Dio>();

  final _getEvidencesTypesPath = "attentionOnRoad/typeEvidence";
  final _saveEvidencePath = "attentionOnRoad/saveEvidence";
  final _saveLocationPath = "attentionOnRoad/saveLocation";
  final _saveSuggestedRoutePath = "attentionOnRoad/saveSuggestedRoute";

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
      final _imageJPG = await ImageHelper.encodeJpg(evidence.photo);
      FormData formData = new FormData.fromMap(
        {
          "dateTime": DateTime.now().millisecondsSinceEpoch,
          "username": service.username,
          "idNovedad": int.tryParse(service.id),
          "idTypeEvidence": evidence.type.id,
          "idTypeStatus":
              TransformationsGrua.serviceStatusToInt(service.status),
          "description": "PRUEBA",
          "file": MultipartFile.fromBytes(
            _imageJPG,
            filename: 'photo',
          )
        },
      );

      final _serverResponse = await _dio.post(
        _saveEvidencePath,
        data: formData,
      );
      if (_serverResponse.data['states_code'] != 200) {
        return Left(ErrorContent.server(_serverResponse.data['message'] ?? ''));
      }

      return Right("Nothing");
    } on Exception catch (e) {
      return Left(ErrorContent.server("Error uploading evidence"));
    }
  }

  @override
  Future<Either<ErrorContent, Unit>> saveLocation({
    required Service service,
    required LatLng location,
  }) async {
    try {
      final _serverResponse = await _dio.post(
        _saveLocationPath,
        data: {
          "id_novedad": service.id,
          "id_type_states":
              TransformationsGrua.serviceStatusToInt(service.status),
          "lat": location.latitude,
          "lng": location.longitude,
          "date_time": DateTime.now().millisecondsSinceEpoch,
          "username": service.username,
        },
      );

      return Right(unit);
    } on Exception catch (e) {
      return Left(ErrorContent.server("Error saving location"));
    }
  }

  @override
  Future<Either<ErrorContent, Unit>> saveServiceSuggestedRoute({
    required Service service,
    required List<RouteDetails> routes,
  }) async {
    try {
      final _suggestedRoutes =
          routes.map((route) => route.toServerMap()).toList();
      final _serverResponse = await _dio.post(
        _saveSuggestedRoutePath,
        data: {
          "id_novedad": int.tryParse(service.id),
          "username": service.username,
          "suggested_route": _suggestedRoutes,
        },
      );

      if (_serverResponse.data['states_code'] != 200) {
        return Left(ErrorContent.server(_serverResponse.data['message']));
      }

      return Right(unit);
    } on Exception catch (e) {
      return Left(ErrorContent.server("Error saving location"));
    }
  }
}
