import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lingon/databaseService.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapState();
}

class MapState extends State<MapPage> {
  Geoflutterfire geo = Geoflutterfire();
  final Firestore _firestore = Firestore.instance;
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition headQuarters = CameraPosition(
    target: LatLng(59.3225207,18.0443221),
    zoom: 14.4746,
  );

  GeolocationStatus geolocationStatus;
  Geolocator geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high, distanceFilter: 10);

  @override
  void initState() {
    super.initState();
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    _refreshLocationPermission();
    _trackPosition(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
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
        onPressed: () {
          _requestHelp(user.uid);
        },
        label: const Text('Help'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _refreshLocationPermission() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
  }

  Future<void> _trackPosition(String userId) async {
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
      await _saveToDB(position: position, userId: userId);
    });
  }

  Future<void> _saveToDB({Position position, String userId}) async {
    try {
      final GeoFirePoint myLocation = geo.point(
          latitude: position.latitude, longitude: position.longitude);
      final Map<String, dynamic> dataMap = <String, dynamic>{
        'name': 'me',
        'position': myLocation.data,
      };
      _firestore
          .collection('locations')
          .document(userId)
          .setData(dataMap);
    } catch (e) {
      print('Could not save position to firebase');
      print(e);
    }
  }

  Future<void> _requestHelp(String userId) async {
    final DatabaseService db = DatabaseService();
    await db.setNeedsHelp(userId: userId, needsHelp: true);
  }
}