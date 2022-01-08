// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_type_server_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvidenceTypeSWrapper _$EvidenceTypeSWrapperFromJson(
        Map<String, dynamic> json) =>
    EvidenceTypeSWrapper(
      listObject: (json['data_list'] as List<dynamic>)
          .map((e) =>
              EvidenceTypeServerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EvidenceTypeSWrapperToJson(
        EvidenceTypeSWrapper instance) =>
    <String, dynamic>{
      'data_list': instance.listObject.map((e) => e.toJson()).toList(),
    };

EvidenceTypeServerModel _$EvidenceTypeServerModelFromJson(
        Map<String, dynamic> json) =>
    EvidenceTypeServerModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$EvidenceTypeServerModelToJson(
        EvidenceTypeServerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
