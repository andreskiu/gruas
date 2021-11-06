import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/core/use_case.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/services/grua_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetServicesUseCase
    extends UseCase<Stream<List<Service>>, GetServicesUseCaseParams> {
  final IGruaService service;

  GetServicesUseCase(this.service);

  @override
  Future<Either<ErrorContent, Stream<List<Service>>>> call(
    GetServicesUseCaseParams params,
  ) async {
    final _error = params.areValid();
    if (_error != null) {
      return Left(_error);
    }

    final _servicesOrFailure = await service.getServices(user: params.user);

    return _servicesOrFailure.fold(
      (fail) {
        return Left(fail);
      },
      (stream) {
        final _newStream = stream.map(
          (serviceList) {
            final _myList = serviceList.where((service) {
              return _isMyCurrentService(service, params.user);
            }).toList();

            if (_myList.isNotEmpty) {
              return _myList;
            }
            final list = serviceList.where((service) {
              return _serviceIsAvailable(service, params.user);
            }).toList();

            if (list.isEmpty) {
              return list;
            }
            list.sort((a, b) {
              return b.requestTime.compareTo(a.requestTime);
              // int cmp = b.requestTime.compareTo(a.requestTime);
              // if (cmp != 0) return cmp;
              // return b.active.compareTo(a.active);
            });
            return list;
          },
        );
        return Right(_newStream);
      },
    );
  }

  bool _isMyCurrentService(Service service, User user) {
    return service.username == user.username &&
        (service.status == ServiceStatus.accepted ||
            service.status == ServiceStatus.carPicked);
  }

  bool _serviceIsAvailable(Service service, User user) {
    return service.status == ServiceStatus.pending &&
        service.username.isEmpty &&
        user.serviceOffered == service.type;
  }
}

class GetServicesUseCaseParams extends Equatable {
  final User user;

  GetServicesUseCaseParams({
    required this.user,
  });

  ErrorContent? areValid() {
    return null;
  }

  @override
  List<Object> get props => [user];
}
