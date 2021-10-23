import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_base/domain/auth/models/user.dart';

class Service extends Equatable {
  final String id;
  final ServiceType type;
  final String clientName;
  final ServiceStatus status;
  final LatLng clientLocation;
  final LatLng detinationLocation;
  final DateTime requestTime;
  final String username;
  final String carModel;

  Service({
    required this.type,
    required this.clientName,
    this.status = ServiceStatus.pending,
    required this.clientLocation,
    required this.detinationLocation,
    required this.carModel,
    required this.requestTime,
    required this.username,
    required this.id,
  });

  factory Service.empty() {
    return Service(
      id: "",
      type: ServiceType.grua,
      clientName: "",
      clientLocation: LatLng(0, 0),
      detinationLocation: LatLng(0, 0),
      carModel: "",
      requestTime: DateTime.now(),
      username: "",
    );
  }
  @override
  List<Object?> get props => [
        id,
        type,
        clientName,
        status,
        clientLocation,
        detinationLocation,
        carModel,
        username,
        requestTime.millisecondsSinceEpoch
      ];

  Service copyWith({
    String? id,
    ServiceType? type,
    String? clientName,
    ServiceStatus? status,
    LatLng? clientLocation,
    LatLng? detinationLocation,
    DateTime? requestTime,
    String? username,
    String? carModel,
  }) {
    return Service(
      id: id ?? this.id,
      type: type ?? this.type,
      clientName: clientName ?? this.clientName,
      status: status ?? this.status,
      clientLocation: clientLocation ?? this.clientLocation,
      detinationLocation: detinationLocation ?? this.detinationLocation,
      requestTime: requestTime ?? this.requestTime,
      username: username ?? this.username,
      carModel: carModel ?? this.carModel,
    );
  }
}

enum ServiceStatus { pending, accepted, carPicked, finished }
