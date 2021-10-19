import 'package:equatable/equatable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Service extends Equatable {
  final ServiceType type;
  final String clientName;
  final serviceStatus status;
  final LatLng clientLocation;
  final LatLng detinationLocation;
  final DateTime requestTime;
  final String userId;
  final String carModel;

  Service({
    required this.type,
    required this.clientName,
    this.status = serviceStatus.pending,
    required this.clientLocation,
    required this.detinationLocation,
    required this.carModel,
    required this.requestTime,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        type,
        clientName,
        status,
        clientLocation,
        detinationLocation,
        carModel,
        userId,
        requestTime.millisecondsSinceEpoch
      ];
}

enum serviceStatus { pending, accepted, carPicked, finished }
