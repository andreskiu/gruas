import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/grua/grua_service_state.dart';
import 'package:flutter_base/config/maps/constants.dart';
import 'package:flutter_base/domain/auth/models/user.dart';
import 'package:flutter_base/domain/grua/models/route_details.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/domain/grua/use_cases/get_service_routes.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wakelock/wakelock.dart';

enum ViewMode {
  preview,
  drive,
}

const CURRENT_PATH_ID = 0; //'current_path';
const CLIENT_PATH_ID = 1; //'client_path';

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

  // late Future<Stream<LocationData>?> initLocationService;
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
    _mapsReady = GetIt.I.getAsync<GruaServiceState>().then((state) async {
      _state = state;
      locationStream = await _startLocation();
      _updatePathStream = state.updateRoutesStream.stream;
      _updateRoutesSubscription = _updatePathStream.listen(_refreshRoutes);

      _state.updateRoutesStream.sink.add(true);
      if (widget.viewMode == ViewMode.drive) {
        _locationSubscription = locationStream?.listen(_onNewLocationDetected);
        // TODO: HACER QUE LA PANTALLA NO SE BLOQUEE SI ESTAMOS EN DRIVE MODE
        // https://flutteragency.com/how-to-keep-application-awake-in-flutter/
        Wakelock.enable();
      }
      return true;
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

    if (widget.viewMode == ViewMode.preview &&
        widget.service.type == ServiceType.grua) {
      await _drawClientPath();

      await _drawCurrentPath(
          widget.service.serviceAcceptedFromLocation ?? _currentPosition);
    } else {
      await _drawCurrentPath(_currentPosition);
      _state.saveLocation(location: _currentPosition);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.viewMode == ViewMode.drive) {
      Wakelock.disable();
    }
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

      // move the map
      if (widget.viewMode == ViewMode.drive) {
        final _currentPoint = LatLng(location.latitude!, location.longitude!);
        _goToLocation(_currentPoint);
      }
    }
  }

  Future<Stream<LocationData>?> _startLocation() async {
    Location locationService = new Location();
    _state.locationService = locationService;
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
      // quizas un set state aqui, para la primera vez
      _currentLocation = await locationService.getLocation();
    } on Exception catch (e) {
      // TODO
    }

    return locationService.onLocationChanged;
  }

  Future<bool> _prepareMap() async {
    return true;
  }

  late Future<bool> _mapsReady;

  Future<void> _drawClientPath() async {
    final path = await _getDestinationRoute(
      id: CLIENT_PATH_ID,
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
    if (widget.service.type == ServiceType.grua) {
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
    } else {
      _finalLocation = widget.service.clientLocation;
    }

    final path = await _getDestinationRoute(
      id: CURRENT_PATH_ID,
      origin: currentPosition,
      destination: _finalLocation,
      color: Colors.blue,
    );
    _addToRoutes(path);
  }

  Polyline? routeToDestination;
  Polyline? currentRoute;

  Future<RouteDetails?> _getRoutesData(
    LatLng origin,
    LatLng destination,
    int routeId,
  ) async {
    final _params = GetServiceRouteUseCaseParams(
      origin: origin,
      destination: destination,
      type: routeId,
    );
    final _linesOrFailure = await getRoutePoints.call(_params);

    return _linesOrFailure.fold(
      (l) => null,
      (route) {
        _state.setRoute(routeId, route);
        return route;
      },
    );
  }

  Future<Polyline?> _getDestinationRoute({
    required int id,
    Color color = Colors.black,
    required LatLng origin,
    required LatLng destination,
  }) async {
    final linesResult = await _getRoutesData(
      origin,
      destination,
      id,
    );
    if (linesResult == null) {
      return null;
    }
    final Polyline polyline = _createPolylineFromPoints(
      id: id.toString(),
      points: linesResult.routeDetails.polylinesPoints.points,
      color: color,
    );

    return polyline;
  }

  Polyline _createPolylineFromPoints({
    required String id,
    required List<LatLng> points,
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

              if (_currentLocation.latitude != null &&
                  _currentLocation.longitude != null) {
                final _position = LatLng(
                    _currentLocation.latitude!, _currentLocation.longitude!);
                _goToLocation(_position);
              }
              // });
            },
            polylines: _routes,
            gestureRecognizers: {
              Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()),
            },
            // parece que los limites no funcionan de lo mejor
            // cameraTargetBounds: _state.routeToClient == null
            //     ? CameraTargetBounds.unbounded
            //     : CameraTargetBounds(
            //         LatLngBounds(
            //           southwest: _state
            //               .routeToClient!.routeDetails.bounds.southwest
            //               .toLatLng(),
            //           northeast: _state
            //               .routeToClient!.routeDetails.bounds.northeast
            //               .toLatLng(),
            //         ),
            //       ),
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
              if (widget.service.type == ServiceType.grua) ...[
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
              ]
            },
          );
          // });
        });
  }

  Future<void> _goToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    final _position = CameraPosition(
      target: location,
      zoom: widget.viewMode == ViewMode.preview ? 12 : 18,
      // bearing: widget.viewMode == ViewMode.preview
      //     ? 0.0
      //     : _currentLocation.heading ?? 0.0,
      // tilt: widget.viewMode == ViewMode.preview ? 0.0 : 75,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  }

  // Future<void> _setInitialCameraPosition(LatLng location) async {
  //   final GoogleMapController controller = await _controller.future;
  //   final _cameraPosition = CameraPosition(target: location);
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  // }
}
