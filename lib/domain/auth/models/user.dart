import 'package:equatable/equatable.dart';

import 'session_information.dart';

class User extends Equatable {
  final String id;
  final SessionInformation? session;
  final String username;
  final String name;
  User({
    required this.id,
    this.session,
    required this.username,
    required this.name,
  });

  User copyWith({
    String? id,
    SessionInformation? session,
    String? username,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      session: session ?? this.session,
      username: username ?? this.username,
      name: name ?? this.name,
    );
  }

  factory User.empty() {
    return User(id: "0", username: "", name: "");
  }

  @override
  List<Object?> get props => [
        id,
        session,
        username,
        name,
      ];
}
