import 'package:equatable/equatable.dart';

import 'package:flutter_base/domain/auth/models/user.dart';

class Service extends Equatable {
  final ServiceType type;
  final String clientName;
  final serviceStatus status;
  // final LatLng location;
  Service({
    required this.type,
    required this.clientName,
    this.status =serviceStatus.pending,
    // required this.location,
  });
  @override
  List<Object?> get props => [
        type,
        clientName,
      ];
}

enum serviceStatus { pending, accepted, carPicked, finished }