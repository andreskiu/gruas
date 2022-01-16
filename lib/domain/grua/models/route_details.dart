import 'package:flutter_base/infrastructure/grua/models/firebase_route_model.dart';

class RouteDetails {
  // distance in meters
  final double totalDistance;
  // time in seconds
  final double totalTime;

  final FirebaseRouteModel routeDetails;
  RouteDetails({
    required this.routeDetails,
    required this.totalDistance,
    required this.totalTime,
  });

  String getDistanceLabel() {
    return (totalDistance / 1000).toStringAsFixed(2) + " KM";
  }

  String getDurationLabel() {
    return (totalTime / 60).toStringAsFixed(2) + " KM";
  }
}
