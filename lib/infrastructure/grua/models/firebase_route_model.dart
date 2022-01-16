import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_route_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FirebaseRouteModel extends Equatable {
  @JsonKey(name: 'overview_polyline')
  final OverviewPolylines polylinesPoints;
  final List<Leg> legs;

  FirebaseRouteModel({
    required this.legs,
    required this.polylinesPoints,
  });

  factory FirebaseRouteModel.fromJson(Map<String, dynamic> json) =>
      _$FirebaseRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseRouteModelToJson(this);
  @override
  List<Object?> get props => [
        polylinesPoints,
        legs,
      ];
}

@JsonSerializable(explicitToJson: true)
class OverviewPolylines {
  @JsonKey(fromJson: _decodeEncodedPolyline)
  final List<LatLng> points;

  OverviewPolylines({
    required this.points,
  });

  factory OverviewPolylines.fromJson(Map<String, dynamic> json) =>
      _$OverviewPolylinesFromJson(json);

  Map<String, dynamic> toJson() => _$OverviewPolylinesToJson(this);
}

List<LatLng> _decodeEncodedPolyline(String encoded) {
  List<LatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    poly.add(p);
  }
  return poly;
}

@JsonSerializable(explicitToJson: true)
class Leg extends Equatable {
  final Distance distance;
  final Duration duration;
  @JsonKey(name: 'start_location')
  final Location startLocation;
  @JsonKey(name: 'end_location')
  final Location endLocation;
  final List<Step> steps;

  Leg({
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    required this.steps,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => _$LegFromJson(json);

  Map<String, dynamic> toJson() => _$LegToJson(this);
  @override
  List<Object?> get props => [
        distance,
        duration,
        startLocation,
        endLocation,
        steps,
      ];
}

@JsonSerializable(explicitToJson: true)
class Distance extends Equatable {
  final String text;
  final int value;
  Distance({
    required this.text,
    required this.value,
  });

  factory Distance.fromJson(Map<String, dynamic> json) =>
      _$DistanceFromJson(json);

  Map<String, dynamic> toJson() => _$DistanceToJson(this);

  @override
  List<Object?> get props => [text, value];
}

@JsonSerializable(explicitToJson: true)
class Duration extends Equatable {
  final String text;
  final int value;
  Duration({
    required this.text,
    required this.value,
  });

  factory Duration.fromJson(Map<String, dynamic> json) =>
      _$DurationFromJson(json);

  Map<String, dynamic> toJson() => _$DurationToJson(this);

  @override
  List<Object?> get props => [text, value];
}

@JsonSerializable(explicitToJson: true)
class Location extends Equatable {
  final double lat;
  final double lng;
  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
  @override
  List<Object?> get props => [
        lat,
        lng,
      ];
}

@JsonSerializable(explicitToJson: true)
class Step extends Equatable {
  final Distance distance;
  final Duration duration;
  @JsonKey(name: 'start_location')
  final Location startLocation;
  @JsonKey(name: 'end_location')
  final Location endLocation;
  Step({
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
  });

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);

  Map<String, dynamic> toJson() => _$StepToJson(this);
  @override
  List<Object?> get props => [
        distance,
        duration,
        startLocation,
        endLocation,
      ];
}
