import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lingon/databaseService.dart';
import 'package:lingon/userModel.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapState();
}

class MapState extends State<MapPage> {
  bool shouldTrackUser = false;
  Geoflutterfire geo = Geoflutterfire();
  final Firestore _firestore = Firestore.instance;
  final Completer<GoogleMapController> _controller = Completer();
  Stream<Position> positionStream;

  static const CameraPosition headQuarters = CameraPosition(
    target: LatLng(59.3225207,18.0443221),
    zoom: 14.4746,
  );

  GeolocationStatus geolocationStatus;
  Geolocator geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high, distanceFilter: 10);

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    final UserData userData = Provider.of<UserData>(context);
    setState(() {
      shouldTrackUser = userData.private.needsHelp;
    });
    _trackPosition(user.uid);
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
      floatingActionButton:
        userData.private.needsHelp && geolocationStatus == GeolocationStatus.granted
            ? FloatingActionButton.extended(
          onPressed: () {
            _requestHelp(userId: user.uid, needsHelp: false);
          },
          label: const Text('Disable'),
          icon: Icon(Icons.close),
        ): FloatingActionButton.extended(
          onPressed: () async {
            if(positionStream == null) {
              print('Requesting position');
              try{
                await geolocator.getCurrentPosition();
                await _trackPosition(user.uid);
              } catch (e) {
                print(e);
              }
            }
            _requestHelp(userId: user.uid, needsHelp: true);
          },
          label: const Text('Request help'),
          icon: Icon(Icons.check),
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
    if(positionStream != null) {
      print('You already have a position stream');
      return;
    }

     positionStream = geolocator.getPositionStream(locationOptions);
     positionStream.listen((Position position) async {
      if (position == null || !shouldTrackUser) {
        print('Position $position shouldTrack $shouldTrackUser');
        return;
      }
      print('New position');
      final GoogleMapController controller = await _controller.future;
      final CameraUpdate _cameraPosition = CameraUpdate.newLatLng(
        LatLng(
          position.latitude,
          position.longitude,
        ),
      );
      controller.animateCamera(_cameraPosition);
      await _saveToDB(position: position, userId: userId);
    });
  }

  Future<void> _saveToDB({Position position, String userId}) async {
    try {
      final GeoFirePoint myLocation = geo.point(
          latitude: position.latitude, longitude: position.longitude);
      final Map<String, dynamic> dataMap = <String, dynamic>{
        'active': true,
        'position': myLocation.data,
      };
      _firestore
          .collection('locations')
          .document(userId)
          .setData(dataMap, merge: true);
    } catch (e) {
      print('Could not save position to firebase');
      print(e);
    }
  }

  Future<void> _requestHelp({String userId, bool needsHelp}) async {
    final DatabaseService db = DatabaseService();
    await db.setNeedsHelp(userId: userId, needsHelp: needsHelp);
  }
}