import 'package:equatable/equatable.dart';

// abstract class Failure<T, R> {
//   ErrorContent getError();
//   Problem<T, R> problem;

//   Failure({
//     required this.problem,
//   });
// }

// class Problem<T, R> {
//   Problem({
//     required this.error,
//     required this.type,
//   });
//   Either<T, R> error;
//   ProblemTypes type;
// }

// enum ProblemTypes { UseCase, Field }
enum ErrorOrigin { UseCase, Field, Server }

class ErrorContent extends Equatable {
  final String message;
  final int errorCode;
  final bool needsTranslation;
  final ErrorOrigin errorOrigin;
  final String msgParams;

  const ErrorContent({
    this.message = "",
    this.errorCode = 0,
    this.needsTranslation = true,
    this.errorOrigin = ErrorOrigin.UseCase,
    this.msgParams = "",
  });

  factory ErrorContent.field(
    String message, {
    String param = "",
  }) =>
      ErrorContent(
        errorOrigin: ErrorOrigin.Field,
        message: message,
        msgParams: param,
      );

  factory ErrorContent.server(
    String message, {
    String param = "",
  }) =>
      ErrorContent(
        errorOrigin: ErrorOrigin.Server,
        message: message,
        msgParams: param,
      );

  factory ErrorContent.useCase(
    String message, {
    String param = "",
  }) =>
      ErrorContent(
        errorOrigin: ErrorOrigin.UseCase,
        message: message,
        msgParams: param,
      );

  @override
  List<Object> get props => [
        message,
        errorCode,
        needsTranslation,
      ];

  ErrorContent copyWith({
    String? message,
    int? errorCode,
    bool? needsTranslation,
    ErrorOrigin? errorOrigin,
  }) {
    return ErrorContent(
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      needsTranslation: needsTranslation ?? this.needsTranslation,
      errorOrigin: errorOrigin ?? this.errorOrigin,
    );
  }
}
