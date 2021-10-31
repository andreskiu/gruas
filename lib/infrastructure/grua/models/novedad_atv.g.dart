// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novedad_atv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovedadAtv _$NovedadAtvFromJson(Map<String, dynamic> json) => NovedadAtv(
      idAtvEstado:
          TransformationsGrua.intToServiceStatus(json['idAtvEstado'] as int),
      idAtvNovedad: json['idAtvNovedad'] as int,
      idAtvTipoServicio: TransformationsGrua.intToServiceType(
          json['idAtvTipoServicio'] as int),
      latInicio: json['latInicio'] as String,
      lngInicio: json['lngInicio'] as String,
      latFin: json['latFin'] as String,
      lngFin: json['lngFin'] as String,
      username: json['username'] as String,
      vehiculo: json['vehiculo'] as String,
    );

Map<String, dynamic> _$NovedadAtvToJson(NovedadAtv instance) =>
    <String, dynamic>{
      'idAtvEstado':
          TransformationsGrua.serviceStatusToInt(instance.idAtvEstado),
      'idAtvNovedad': instance.idAtvNovedad,
      'idAtvTipoServicio':
          TransformationsGrua.serviceTypeToInt(instance.idAtvTipoServicio),
      'latInicio': instance.latInicio,
      'lngInicio': instance.lngInicio,
      'latFin': instance.latFin,
      'lngFin': instance.lngFin,
      'username': instance.username,
      'vehiculo': instance.vehiculo,
    };
