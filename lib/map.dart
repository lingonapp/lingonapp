import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapState();
}

class MapState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition headQuarters = CameraPosition(
    target: LatLng(59.3225207,18.0443221),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  GeolocationStatus geolocationStatus;
  Geolocator geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high, distanceFilter: 10);

  @override
  void initState() {
    super.initState();
    _refreshLocationPermission();
    _trackPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: headQuarters,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Help'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _refreshLocationPermission() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
  }

  Future<void> _trackPosition() async {
    await _refreshLocationPermission();
    print('status' + geolocationStatus.toString());
    if(geolocationStatus == GeolocationStatus.denied) {
      return;
    }
    final LocationOptions locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 25);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() + ', ' + position.longitude.toString());
    });
  }

  Future<void> _goToTheLake() async {

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}