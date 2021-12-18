// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_type_server_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvidenceTypeSWrapper _$EvidenceTypeSWrapperFromJson(
        Map<String, dynamic> json) =>
    EvidenceTypeSWrapper(
      listObject: (json['listObject'] as List<dynamic>)
          .map((e) =>
              EvidenceTypeServerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EvidenceTypeSWrapperToJson(
        EvidenceTypeSWrapper instance) =>
    <String, dynamic>{
      'listObject': instance.listObject.map((e) => e.toJson()).toList(),
    };

EvidenceTypeServerModel _$EvidenceTypeServerModelFromJson(
        Map<String, dynamic> json) =>
    EvidenceTypeServerModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String?,
      descripcion: json['descripcion'] as String?,
    );

Map<String, dynamic> _$EvidenceTypeServerModelToJson(
        EvidenceTypeServerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
    };
