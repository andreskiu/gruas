import 'package:dartz/dartz.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/core/error_content.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/domain/grua/models/route_details.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/models/evidence.dart';
import 'package:flutter_base/infrastructure/grua/models/firebase_route_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

abstract class IGruaService {
  Future<Either<ErrorContent, Stream<List<Service>>>> getServices({
    required User user,
  });
  Future<Either<ErrorContent, Service>> saveService({
    required Service service,
    required LocationData? location,
  });

  Future<Either<ErrorContent, String>> uploadPhoto({
    required Service service,
    required Evidence evidence,
  });
  Future<Either<ErrorContent, List<EvidenceType>>> getEvidenceTypes();

  Future<Either<ErrorContent, FirebaseRouteModel>> getServiceRoute({
    required LatLng origin,
    required LatLng destination,
  });
  Future<Either<ErrorContent, Unit>> saveServiceSuggestedRoute({
    required Service service,
    required List<RouteDetails> routes,
  });

  Future<Either<ErrorContent, Unit>> saveLocation({
    required Service service,
    required LatLng location,
  });
}
