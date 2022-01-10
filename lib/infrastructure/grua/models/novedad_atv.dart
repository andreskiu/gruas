import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/infrastructure/grua/models/transformations_grua.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'novedad_atv.g.dart';

@JsonSerializable()
class NovedadAtv extends Equatable {
  @JsonKey(
    includeIfNull: true,
    fromJson: TransformationsGrua.intToServiceStatus,
    toJson: TransformationsGrua.serviceStatusToInt,
  )
  final ServiceStatus idAtvEstado;
  final int idAtvNovedad;

  @JsonKey(
    fromJson: TransformationsGrua.intToServiceType,
    toJson: TransformationsGrua.serviceTypeToInt,
  )
  final ServiceType idAtvTipoServicio;
  final String latInicio;
  final String lngInicio;
  final String latFin;
  final String lngFin;
  @JsonKey(defaultValue: '')
  final String latServicioAceptado;
  @JsonKey(defaultValue: '')
  final String lngServicioAceptado;
  final String username;
  @JsonKey(defaultValue: '')
  final String vehiculo;

  final DateTime? fechaSolicitud;

  final DateTime? fechaServicioAceptado;
  final DateTime? fechaVehiculoRecogido;
  final DateTime? fechaServicioFinalizado;

  NovedadAtv({
    required this.fechaSolicitud,
    required this.idAtvEstado,
    required this.idAtvNovedad,
    required this.idAtvTipoServicio,
    required this.latInicio,
    required this.lngInicio,
    required this.latFin,
    required this.lngFin,
    required this.latServicioAceptado,
    required this.lngServicioAceptado,
    required this.username,
    required this.vehiculo,
    this.fechaServicioAceptado,
    this.fechaVehiculoRecogido,
    this.fechaServicioFinalizado,
  });

  @override
  List<Object?> get props => [
        fechaSolicitud,
        idAtvEstado,
        idAtvNovedad,
        idAtvTipoServicio,
        latInicio,
        lngInicio,
        latFin,
        lngFin,
        latServicioAceptado,
        lngServicioAceptado,
        username,
        vehiculo,
        fechaServicioAceptado,
        fechaVehiculoRecogido,
        fechaServicioFinalizado,
      ];

  Service toService() {
    late LatLng _clientLocation;
    final _clientLat = double.tryParse(latInicio);
    final _clientLng = double.tryParse(lngInicio);
    if (_clientLat != null && _clientLng != null) {
      _clientLocation = LatLng(_clientLat, _clientLng);
    }

    late LatLng _destinationPlace;
    final _destinationLat = double.tryParse(latFin);
    final _destinationLng = double.tryParse(lngFin);
    if (_destinationLat != null && _destinationLng != null) {
      _destinationPlace = LatLng(_destinationLat, _destinationLng);
    }
    LatLng? _serviceAcceptedFrom;
    final _serviceAcceptedFromLat = double.tryParse(latServicioAceptado);
    final _serviceAcceptedFromLng = double.tryParse(lngServicioAceptado);
    if (_serviceAcceptedFromLat != null && _serviceAcceptedFromLng != null) {
      _serviceAcceptedFrom = LatLng(
        _serviceAcceptedFromLat,
        _serviceAcceptedFromLng,
      );
    }

    return Service(
      id: idAtvNovedad.toString(),
      type: idAtvTipoServicio,
      status: idAtvEstado,
      clientName: "",
      clientLocation: _clientLocation,
      detinationLocation: _destinationPlace,
      serviceAcceptedFromLocation: _serviceAcceptedFrom,
      carModel: vehiculo,
      requestTime: fechaSolicitud ?? DateTime.now(),
      username: username,
      serviceAcceptedTime: fechaServicioAceptado,
      serviceFinishedTime: fechaServicioFinalizado,
      carPickedTime: fechaVehiculoRecogido,
    );
  }

  factory NovedadAtv.fromService(Service service) {
    return NovedadAtv(
      fechaSolicitud: service.requestTime,
      idAtvEstado: service.status,
      idAtvNovedad: int.tryParse(service.id)!,
      idAtvTipoServicio: service.type,
      latInicio: service.clientLocation.latitude.toString(),
      lngInicio: service.clientLocation.longitude.toString(),
      latFin: service.detinationLocation.latitude.toString(),
      lngFin: service.detinationLocation.longitude.toString(),
      latServicioAceptado:
          service.serviceAcceptedFromLocation?.latitude.toString() ?? '',
      lngServicioAceptado:
          service.serviceAcceptedFromLocation?.longitude.toString() ?? '',
      username: service.username,
      vehiculo: service.carModel,
      fechaServicioAceptado: service.serviceAcceptedTime,
      fechaServicioFinalizado: service.serviceFinishedTime,
      fechaVehiculoRecogido: service.carPickedTime,
    );
  }

  factory NovedadAtv.fromJson(Map<String, dynamic> json) =>
      _$NovedadAtvFromJson(json);

  Map<String, dynamic> toJson() => _$NovedadAtvToJson(this);
}
