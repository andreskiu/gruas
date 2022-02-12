import 'package:equatable/equatable.dart';

import 'session_information.dart';

class User extends Equatable {
  final String id;
  final SessionInformation? session;
  final String username;
  final String name;
  final ServiceType serviceOffered;
  User({
    required this.id,
    this.session,
    required this.username,
    required this.name,
    required this.serviceOffered,
  });

  User copyWith({
    String? id,
    SessionInformation? session,
    String? username,
    String? name,
    ServiceType? serviceOffered,
  }) {
    return User(
      id: id ?? this.id,
      session: session ?? this.session,
      username: username ?? this.username,
      name: name ?? this.name,
      serviceOffered: serviceOffered ?? this.serviceOffered,
    );
  }

  factory User.empty() {
    return User(
      id: "",
      username: "",
      name: "",
      serviceOffered: ServiceType.grua,
    );
  }

  @override
  List<Object?> get props => [
        id,
        session,
        username,
        name,
      ];
}

enum ServiceType { grua, motoTaller, carroTaller }
