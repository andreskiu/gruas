import 'package:equatable/equatable.dart';

class SessionInformation extends Equatable {
  final String sessionId;
  final DateTime expireSession;
  SessionInformation({
    required this.sessionId,
    required this.expireSession,
  });

  @override
  List<Object?> get props => [sessionId, expireSession];

  SessionInformation copyWith({
    String? sessionId,
    DateTime? expireSession,
  }) {
    return SessionInformation(
      sessionId: sessionId ?? this.sessionId,
      expireSession: expireSession ?? this.expireSession,
    );
  }

  factory SessionInformation.empty() {
    return SessionInformation(
      sessionId: "",
      expireSession: DateTime.now(),
    );
  }
}
