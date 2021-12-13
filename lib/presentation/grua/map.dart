import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/application/grua/grua_service_state.dart';
import 'package:flutter_base/config/maps/constants.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/use_cases/get_service_routes.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

enum ViewMode {
  preview,
  drive,
}

class ServiceMap extends StatefulWidget {
  ServiceMap({
    Key? key,
    required this.service,
    this.viewMode = ViewMode.preview,
    this.shouldUpdateUserPosition = false,
  }) : super(key: key);
  final Service service;
  final ViewMode viewMode;
  final bool shouldUpdateUserPosition;

  @override
  _ServiceMapState createState() => _ServiceMapState();
}

class _ServiceMapState extends State<ServiceMap> {
  final getRoutePoints = GetIt.I.get<GetServiceRouteUseCase>();
  Completer<GoogleMapController> _controller = Completer();

  late Future<Stream<LocationData>?> initLocationService;
  late GruaServiceState _state;
  Stream<LocationData>? locationStream;
  StreamSubscription<LocationData>? _locationSubscription;
  late StreamSubscription<bool> _updateRoutesSubscription;
  final Set<Polyline> _routes = <Polyline>{};
  late LocationData _currentLocation;
  late Stream<bool> _updatePathStream;
  @override
  void initState() {
    super.initState();
    _mapsReady = prepareMap();

    GetIt.I.getAsync<GruaServiceState>().then((state) async {
      _state = state;
      locationStream = await _startLocation();
      _updatePathStream = state.updateRoutesStream.stream;
      _updateRoutesSubscription = _updatePathStream.listen(_refreshRoutes);

      _state.updateRoutesStream.sink.add(true);
      if (widget.viewMode == ViewMode.drive) {
        _locationSubscription = locationStream?.listen(_onNewLocationDetected);
      }
    });
  }

  Future<void> _refreshRoutes(bool nothing) async {
    LatLng? _currentPosition;
    if (_currentLocation.latitude != null &&
        _currentLocation.longitude != null) {
      _currentPosition = LatLng(
        _currentLocation.latitude!,
        _currentLocation.longitude!,
      );
    }
    if (_currentPosition == null) {
      await Future.delayed(Duration(milliseconds: 500));
      return _refreshRoutes(true);
    }

    if (widget.viewMode == ViewMode.preview) {
      await _drawClientPath();

      await _drawCurrentPath(
          widget.service.serviceAcceptedFromLocation ?? _currentPosition);
    } else {
      await _drawCurrentPath(_currentPosition);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();

    _locationSubscription?.cancel();
    _updateRoutesSubscription.cancel();
  }

  _onNewLocationDetected(LocationData location) {
    if (_state.lastLocation == location) {
      return;
    }
    _state.lastLocation = location;

    if (location.latitude != null && location.longitude != null) {
      _currentLocation = location;
      _refreshRoutes(true);

      // TODO: move the map when driving
      // move the map
      // if (widget.viewMode == ViewMode.drive) {
      //   _goToLocation(_currentPosition);
      // }
    }
  }

  Future<Stream<LocationData>?> _startLocation() async {
    Location locationService = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    print("Starting location");
    _serviceEnabled = await locationService.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationService.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await locationService.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationService.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    locationService.changeSettings(
      interval: MapConstants.LocationIntervalUpdate,
      distanceFilter: MapConstants.LocationDistanceUpdate,
    );
    try {
      _currentLocation = await locationService.getLocation();
    } on Exception catch (e) {
      // TODO
    }

    return locationService.onLocationChanged;
    // return _locationData;
  }

  Future<bool> prepareMap() async {
    return true;
  }

  late Future<bool> _mapsReady;

  Future<void> _drawClientPath() async {
    final path = await _getDestinationRoute(
      id: "client_path",
      origin: widget.service.clientLocation,
      destination: widget.service.detinationLocation,
      color: Colors.green,
    );

    _addToRoutes(path);
  }

  void _addToRoutes(Polyline? route) {
    if (route == null) {
      return;
    }
    if (mounted) {
      setState(() {
        _routes.removeWhere((path) => path.polylineId == route.polylineId);
        _routes.add(route);
      });
    }
  }

  Future<void> _drawCurrentPath(LatLng currentPosition) async {
    late final _finalLocation;
    switch (widget.service.status) {
      case ServiceStatus.pending:
        _finalLocation = widget.service.clientLocation;
        break;
      case ServiceStatus.accepted:
        _finalLocation = widget.service.clientLocation;
        break;
      case ServiceStatus.carPicked:
        _finalLocation = widget.service.detinationLocation;
        break;
      case ServiceStatus.finished:
        _finalLocation = widget.service.detinationLocation;
        break;
    }

    final path = await _getDestinationRoute(
      id: "current_path",
      origin: currentPosition,
      destination: _finalLocation,
      color: Colors.blue,
    );
    _addToRoutes(path);
  }

  Polyline? routeToDestination;
  Polyline? currentRoute;

  Future<PolylineResult?> _getRoutesData(
    LatLng origin,
    LatLng destination,
  ) async {
    final _params = GetServiceRouteUseCaseParams(
      origin: origin,
      destination: destination,
    );
    final _linesOrFailure = await getRoutePoints.call(_params);

    return _linesOrFailure.fold((l) => null, (result) => result);
  }

  Future<Polyline?> _getDestinationRoute({
    required String id,
    Color color = Colors.black,
    required LatLng origin,
    required LatLng destination,
  }) async {
    final linesResult = await _getRoutesData(
      origin,
      destination,
    );
    if (linesResult == null) {
      return null;
    }
    final Polyline polyline = _createPolylineFromPoints(
      id: id,
      points: linesResult.points,
      color: color,
    );

    return polyline;
  }

  Polyline _createPolylineFromPoints({
    required String id,
    required List<PointLatLng> points,
    Color color = Colors.black,
  }) {
    return Polyline(
      polylineId: PolylineId(id),
      points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    const CameraPosition _bogota = CameraPosition(
      target: LatLng(4.6917, -74.0801),
      zoom: 14.4746,
    );

    return FutureBuilder<bool>(
        future: _mapsReady,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          final _client = widget.service.clientName.isEmpty
              ? "cliente"
              : widget.service.clientName;
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _bogota,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) async {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
              // esto llevaba el mapa a a ubicacion del usuario. quizas deberiamos en modo conduccion
              // initLocationService.then((value) {
              //   if (_locationData != null) {
              //     if (_locationData!.latitude != null &&
              //         _locationData!.longitude != null) {
              //       final _position = LatLng(_locationData!.latitude!,
              //           _locationData!.longitude!);
              //       _goToLocation(_position);
              //     }
              //   }
              // });
            },
            polylines: _routes,
            markers: {
              Marker(
                markerId: MarkerId(
                  _client,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
                position: widget.service.clientLocation,
                infoWindow: InfoWindow(
                  title: _client,
                  snippet: widget.service.carModel,
                ),
              ),
              Marker(
                markerId: MarkerId(
                  "destination",
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
                position: widget.service.detinationLocation,
                infoWindow: InfoWindow(
                  title: "Destino",
                ),
              ),
            },
          );
          // });
        });
  }

  Future<void> _goToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    final _position = CameraPosition(target: location, zoom: 15);
    controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  }
}
