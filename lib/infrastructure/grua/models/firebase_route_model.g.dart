// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseRouteModel _$FirebaseRouteModelFromJson(Map<String, dynamic> json) =>
    FirebaseRouteModel(
      legs: (json['legs'] as List<dynamic>)
          .map((e) => Leg.fromJson(e as Map<String, dynamic>))
          .toList(),
      polylinesPoints: OverviewPolylines.fromJson(
          json['overview_polyline'] as Map<String, dynamic>),
      bounds: Bounds.fromJson(json['bounds'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FirebaseRouteModelToJson(FirebaseRouteModel instance) =>
    <String, dynamic>{
      'overview_polyline': instance.polylinesPoints.toJson(),
      'legs': instance.legs.map((e) => e.toJson()).toList(),
      'bounds': instance.bounds.toJson(),
    };

Bounds _$BoundsFromJson(Map<String, dynamic> json) => Bounds(
      southwest: Location.fromJson(json['southwest'] as Map<String, dynamic>),
      northeast: Location.fromJson(json['northeast'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BoundsToJson(Bounds instance) => <String, dynamic>{
      'southwest': instance.southwest.toJson(),
      'northeast': instance.northeast.toJson(),
    };

OverviewPolylines _$OverviewPolylinesFromJson(Map<String, dynamic> json) =>
    OverviewPolylines(
      points: _decodeEncodedPolyline(json['points'] as String),
    );

Map<String, dynamic> _$OverviewPolylinesToJson(OverviewPolylines instance) =>
    <String, dynamic>{
      'points': instance.points.map((e) => e.toJson()).toList(),
    };

Leg _$LegFromJson(Map<String, dynamic> json) => Leg(
      distance: Distance.fromJson(json['distance'] as Map<String, dynamic>),
      duration: Duration.fromJson(json['duration'] as Map<String, dynamic>),
      startLocation:
          Location.fromJson(json['start_location'] as Map<String, dynamic>),
      endLocation:
          Location.fromJson(json['end_location'] as Map<String, dynamic>),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => Step.fromJson(e as Map<String, dynamic>))
          .toList(),
      startAddress: json['start_address'] as String? ?? '',
      endAddress: json['end_address'] as String? ?? '',
    );

Map<String, dynamic> _$LegToJson(Leg instance) => <String, dynamic>{
      'distance': instance.distance.toJson(),
      'duration': instance.duration.toJson(),
      'start_location': instance.startLocation.toJson(),
      'end_location': instance.endLocation.toJson(),
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'start_address': instance.startAddress,
      'end_address': instance.endAddress,
    };

Distance _$DistanceFromJson(Map<String, dynamic> json) => Distance(
      text: json['text'] as String,
      value: json['value'] as int,
    );

Map<String, dynamic> _$DistanceToJson(Distance instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };

Duration _$DurationFromJson(Map<String, dynamic> json) => Duration(
      text: json['text'] as String,
      value: json['value'] as int,
    );

Map<String, dynamic> _$DurationToJson(Duration instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      distance: Distance.fromJson(json['distance'] as Map<String, dynamic>),
      duration: Duration.fromJson(json['duration'] as Map<String, dynamic>),
      startLocation:
          Location.fromJson(json['start_location'] as Map<String, dynamic>),
      endLocation:
          Location.fromJson(json['end_location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'distance': instance.distance.toJson(),
      'duration': instance.duration.toJson(),
      'start_location': instance.startLocation.toJson(),
      'end_location': instance.endLocation.toJson(),
    };
