import 'package:equatable/equatable.dart';

import '../../../domain/core/error_content.dart';

class ServiceFailure with EquatableMixin {
  final int errorCode;
  final String msg;
  final ServiceFailureType type;

  ServiceFailure({
    required this.type,
    this.errorCode = 0,
    this.msg = "",
  });

  ErrorContent getError() {
    String _msg = "";

    switch (type) {
      case ServiceFailureType.ConnectionError:
        _msg =
            "El servidor no ha respondido a tiempo. Por favor, compruebe su conexión a Internet";
        break;
      case ServiceFailureType.BadRequest:
        _msg = "La información enviada es errónea. Por favor actualice la App.";
        break;
      case ServiceFailureType.UnauthorizedUser:
        _msg = "No tienes permiso para realizar esta acción";
        break;
      case ServiceFailureType.NotFound:
        _msg =
            "El servidor está fuera de línea o su aplicación está desactualizada. Por favor, actualice la App.";
        break;
      case ServiceFailureType.CacheError:
        _msg =
            "Hay un problema con su teléfono. Por favor, comprueba que tienes suficiente espacio de almacenamiento e intentelo nuevamente.";
        break;
      case ServiceFailureType.FeatureFailure:
        return ErrorContent(
          message: msg,
          errorCode: errorCode,
        );
      default:
        _msg = "Se ha producido un error. Por favor, inténtelo más tarde.";
        break;
    }

    return ErrorContent(
      message: _msg,
    );
  }

  @override
  List<Object?> get props => [
        errorCode,
        msg,
        type,
      ];
}

enum ServiceFailureType {
  General,
  FormatError,
  UnauthorizedUser,
  ConnectionError,
  BadRequest,
  NotFound,
  CacheError,
  FeatureFailure
}
