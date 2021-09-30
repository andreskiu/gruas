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

    const _basePath = "infrastructure.errors.";
    switch (type) {
      case ServiceFailureType.ConnectionError:
        _msg = _basePath + "connection";
        break;
      case ServiceFailureType.BadRequest:
        _msg = _basePath + "bad_request";
        break;
      case ServiceFailureType.UnauthorizedUser:
        _msg = _basePath + "unauthorized";
        break;
      case ServiceFailureType.NotFound:
        _msg = _basePath + "notFound";
        break;
      case ServiceFailureType.CacheError:
        _msg = _basePath + "cache";
        break;
      case ServiceFailureType.FeatureFailure:
        return ErrorContent(
          message: msg,
          errorCode: errorCode,
        );
      default:
        _msg = _basePath + "general";
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
