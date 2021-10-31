import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/grua/models/service.dart';

class TransformationsGrua {
  static ServiceType intToServiceType(int number) {
    switch (number) {
      case 1:
        return ServiceType.grua;
      case 2:
        return ServiceType.carroTaller;
      case 3:
        return ServiceType.motoTaller;

      default:
        return ServiceType.grua;
    }
  }

  static int serviceTypeToInt(ServiceType type) {
    switch (type) {
      case ServiceType.grua:
        return 1;
      case ServiceType.carroTaller:
        return 2;
      case ServiceType.motoTaller:
        return 3;
    }
  }

  static ServiceStatus intToServiceStatus(int number) {
    switch (number) {
      case 1:
        return ServiceStatus.pending;
      case 2:
        return ServiceStatus.accepted;
      case 3:
        return ServiceStatus.carPicked;
      case 4:
        return ServiceStatus.finished;
      default:
        return ServiceStatus.pending;
    }
  }

  static int serviceStatusToInt(ServiceStatus type) {
    switch (type) {
      case ServiceStatus.pending:
        return 1;
      case ServiceStatus.accepted:
        return 2;
      case ServiceStatus.carPicked:
        return 3;
      case ServiceStatus.finished:
        return 4;
      default:
        return 1;
    }
  }
}
