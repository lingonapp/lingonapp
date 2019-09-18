import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapState();
}

class MapState extends State<MapPage> {
  Geoflutterfire geo = Geoflutterfire();
  final Firestore _firestore = Firestore.instance;
  final Completer<GoogleMapController> _controller = Completer();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    if(geolocationStatus == GeolocationStatus.denied) {
      return;
    }
    final LocationOptions locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 25);

    geolocator.getPositionStream(locationOptions).listen((Position position) async {
      if (position == null) {
        return;
      }
      await _saveToDB(position);
    });
  }

  Future<void> _saveToDB(Position position) async {
    try {
      final GeoFirePoint myLocation = geo.point(
          latitude: position.latitude, longitude: position.longitude);
      final Map<String, dynamic> dataMap = <String, dynamic>{
        'name': 'me',
        'position': myLocation.data,
      };
      final FirebaseUser user = await _auth.currentUser();
      final String userID = await user.getIdToken();
      _firestore
          .collection('locations')
          .document(userID)
          .setData(dataMap);
    } catch (e) {
      print('Could not save position to firebase');
      print(e);
    }
  }

  Future<void> _goToTheLake() async {

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}