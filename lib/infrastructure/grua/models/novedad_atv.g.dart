// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novedad_atv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovedadAtv _$NovedadAtvFromJson(Map<String, dynamic> json) => NovedadAtv(
      fechaSolicitud: json['fechaSolicitud'] == null
          ? null
          : DateTime.parse(json['fechaSolicitud'] as String),
      idAtvEstado:
          TransformationsGrua.intToServiceStatus(json['idAtvEstado'] as int),
      idAtvNovedad: json['idAtvNovedad'] as int,
      idAtvTipoServicio: TransformationsGrua.intToServiceType(
          json['idAtvTipoServicio'] as int?),
      latInicio: json['latInicio'] as String,
      lngInicio: json['lngInicio'] as String,
      latFin: json['latFin'] as String,
      lngFin: json['lngFin'] as String,
      latServicioAceptado: json['latServicioAceptado'] as String? ?? '',
      lngServicioAceptado: json['lngServicioAceptado'] as String? ?? '',
      username: json['username'] as String,
      vehiculo: json['vehiculo'] as String? ?? '',
      fechaServicioAceptado: json['fechaServicioAceptado'] == null
          ? null
          : DateTime.parse(json['fechaServicioAceptado'] as String),
      fechaVehiculoRecogido: json['fechaVehiculoRecogido'] == null
          ? null
          : DateTime.parse(json['fechaVehiculoRecogido'] as String),
      fechaServicioFinalizado: json['fechaServicioFinalizado'] == null
          ? null
          : DateTime.parse(json['fechaServicioFinalizado'] as String),
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
      'latServicioAceptado': instance.latServicioAceptado,
      'lngServicioAceptado': instance.lngServicioAceptado,
      'username': instance.username,
      'vehiculo': instance.vehiculo,
      'fechaSolicitud': instance.fechaSolicitud?.toIso8601String(),
      'fechaServicioAceptado':
          instance.fechaServicioAceptado?.toIso8601String(),
      'fechaVehiculoRecogido':
          instance.fechaVehiculoRecogido?.toIso8601String(),
      'fechaServicioFinalizado':
          instance.fechaServicioFinalizado?.toIso8601String(),
    };
