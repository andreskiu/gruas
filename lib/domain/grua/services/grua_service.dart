import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/infrastructure/grua/models/evidence.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class IGruaService {
  Future<Either<ErrorContent, Stream<List<Service>>>> getServices({
    required User user,
  });
  Future<Either<ErrorContent, Service>> saveService({
    required Service service,
  });

  Future<Either<ErrorContent, String>> uploadPhoto({
    required Service service,
    required Evidence evidence,
  });

  Future<Either<ErrorContent, PolylineResult>> getServiceRoute({
    required LatLng origin,
    required LatLng destination,
  });
}
