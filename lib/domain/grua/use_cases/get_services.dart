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

    return _servicesOrFailure;
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
