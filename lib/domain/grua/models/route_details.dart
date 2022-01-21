import 'package:flutter_base/infrastructure/grua/models/firebase_route_model.dart';

class RouteDetails {
  // distance in meters
  final double totalDistance;
  // time in seconds
  final double totalTime;
  final int type;

  final FirebaseRouteModel routeDetails;
  RouteDetails({
    required this.routeDetails,
    required this.totalDistance,
    required this.totalTime,
    required this.type,
  });

  String getDistanceLabel() {
    return (totalDistance / 1000).toStringAsFixed(2) + " KM";
  }

  String getDurationLabel() {
    return (totalTime / 60).toStringAsFixed(2) + " KM";
  }

  Map<String, dynamic> toServerMap() {
    return {
      "start_location": {
        "lat": routeDetails.legs.first.startLocation.lat,
        "lng": routeDetails.legs.first.startLocation.lng,
      },
      "end_location": {
        "lat": routeDetails.legs.last.endLocation.lat,
        "lng": routeDetails.legs.last.endLocation.lng,
      },
      "duration": totalTime,
      "distance": totalDistance,
      "address_start": routeDetails.legs.first.startAddress,
      "address_end": routeDetails.legs.first.endAddress,
      "type_route": type,
      "steps": routeDetails.polylinesPoints.points
          .map(
            (point) => {
              "lat": point.latitude,
              "lng": point.longitude,
            },
          )
          .toList()
    };
  }
}
