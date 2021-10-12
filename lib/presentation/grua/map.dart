import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ServiceMap extends StatefulWidget {
  ServiceMap({
    Key? key,
    required this.serviceLocation,
  }) : super(key: key);
  final LatLng serviceLocation;

  @override
  _ServiceMapState createState() => _ServiceMapState();
}

class _ServiceMapState extends State<ServiceMap> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? _locationData;
  late BitmapDescriptor _blueIcon;
  late BitmapDescriptor _blackIcon;
  late BitmapDescriptor _greenIcon;
  late BitmapDescriptor _redIcon;


@override
void dispose() {
  
  super.dispose();
}
  Future<void> _startLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
  }

  // Future<BitmapDescriptor> getMarker(String path) async {
  //   const markerSize = 200;
  //   try {
  //     final _redIconBytes = await getBytesFromAsset(
  //       path,
  //       markerSize,
  //     );
  //     if (_redIconBytes != null) {
  //       return BitmapDescriptor.fromBytes(_redIconBytes);
  //     }
  //     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
  //   } catch (e) {
  //     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
  //   }
  // }

  // Future<void> loadBusesImages() async {
  //   _blueIcon = await getMarker(
  //     "assets/images/maps/bus-marker.png",
  //   );
  //   _redIcon = await getMarker(
  //     "assets/images/maps/bus-marker-rojo.png",
  //   );
  //   _blackIcon = await getMarker(
  //     "assets/images/maps/bus-marker-rojo.png",
  //   );
  //   _greenIcon = await getMarker(
  //     "assets/images/maps/bus-marker-verde.png",
  //   );
  //   return;
  // }

  Future<bool> prepareMap() async {
    // await loadBusesImages();

    // needs to return something
    return true;
  }

  // Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   Codec codec = await instantiateImageCodec(
  //     data.buffer.asUint8List(),
  //     targetWidth: width,
  //   );

  //   FrameInfo fi = await codec.getNextFrame();
  //   final bytes = await fi.image.toByteData(
  //     format: ImageByteFormat.png,
  //   );
  //   if (bytes != null) {
  //     return bytes.buffer.asUint8List();
  //   }
  //   return null;
  // }

  // void _onBusTap(BuildContext context, Bus bus) {
  //   Scaffold.of(context).showBottomSheet(
  //     (context) => BusInformation(
  //       bus: bus,
  //     ),
  //     elevation: 12,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(Info.horizontalUnit * 8),
  //         topRight: Radius.circular(Info.horizontalUnit * 8),
  //       ),
  //     ),
  //   );
  // }

  // BitmapDescriptor _selectMarket(Bus bus) {
  //   const maxUpdateBusTime = 15;
  //   final _now = DateTime.now();
  //   if (_now.difference(bus.lastUpdateTime) >
  //       Duration(minutes: maxUpdateBusTime)) {
  //     return _blackIcon;
  //   } else {
  //     if (bus.tour.id == "46") {
  //       return _greenIcon;
  //     }

  //     if (bus.tour.id == "47") {
  //       return _redIcon;
  //     }
  //     return _blueIcon;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _mapsReady = prepareMap();
  }

  late Future<bool> _mapsReady;

  @override
  Widget build(BuildContext context) {
    const CameraPosition _cartagena = CameraPosition(
      target: LatLng(10.394399, -75.488776),
      zoom: 14.4746,
    );
    // return Scaffold(
    //   body:
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
          return StreamBuilder<List<String>>(
              stream: null,
              initialData: [],
              builder: (context, snapshot) {
                // if (!snapshot.hasData || snapshot.data == null) {
                //   return Center(
                //     child: ResponsiveText("No se encontraron colectivos"),
                //   );
                // }
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _cartagena,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) async {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                    _startLocation().then((value) {
                      if (_locationData != null) {
                        if (_locationData!.latitude != null &&
                            _locationData!.longitude != null) {
                          final _position = LatLng(_locationData!.latitude!,
                              _locationData!.longitude!);
                          _goToLocation(_position);
                        }
                      }
                    });
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId(
                        "example",
                      ),
                      // icon: _selectMarket(bus),
                      position: widget.serviceLocation,
                      onTap: () {
                        // _onBusTap(context, bus);
                      },
                      // infoWindow: InfoWindow(
                      //   title: bus.driver,
                      //   snippet: FormatHelper.speedString(bus.speed),
                      // ),
                    ),
                  },
                );
              });
        });
    //   floatingActionButton: Platform.isIOS
    //       ? FloatingActionButton(
    //           child: Icon(
    //             Icons.keyboard_arrow_left,
    //             size: 40,
    //           ),
    //           backgroundColor: Theme.of(context).primaryColor,
    //           onPressed: () {},
    //         )
    //       : SizedBox.shrink(),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    // );
  }

  Future<void> _goToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    final _position = CameraPosition(target: location, zoom: 15);
    controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  }
}
