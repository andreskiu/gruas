// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novedad_atv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovedadAtv _$NovedadAtvFromJson(Map<String, dynamic> json) => NovedadAtv(
      fechaSolicitud: CoreTransformations.dynamicToDate(json['fechaSolicitud']),
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
      fechaServicioAceptado:
          CoreTransformations.dynamicToDate(json['fechaServicioAceptado']),
      fechaVehiculoRecogido:
          CoreTransformations.dynamicToDate(json['fechaVehiculoRecogido']),
      fechaServicioFinalizado:
          CoreTransformations.dynamicToDate(json['fechaServicioFinalizado']),
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
      'fechaSolicitud': CoreTransformations.dateToInt(instance.fechaSolicitud),
      'fechaServicioAceptado':
          CoreTransformations.dateToInt(instance.fechaServicioAceptado),
      'fechaVehiculoRecogido':
          CoreTransformations.dateToInt(instance.fechaVehiculoRecogido),
      'fechaServicioFinalizado':
          CoreTransformations.dateToInt(instance.fechaServicioFinalizado),
    };
