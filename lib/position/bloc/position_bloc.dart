import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import './bloc.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  StreamSubscription<Position> subscription;
  Stream<Position> positionStream;
  GeolocationStatus geolocationStatus;
  Geolocator geolocator = Geolocator();
  final Firestore _firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 50);
  String currentUserId;

  @override
  PositionState get initialState => InitialPositionState();

  @override
  Stream<PositionState> mapEventToState(
    PositionEvent event,
  ) async* {
    if (event is ListenForPosition) {
      currentUserId = event.currentUserId;
      await subscription?.cancel();
      Position lastKnownDeviceLocation =
          await geolocator.getLastKnownPosition();
      if (lastKnownDeviceLocation != null) {
        add(UpdatePosition(position: lastKnownDeviceLocation));
      } else {
        var headQuarters = LatLng(59.3347524, 18.0965903);
        add(UpdatePosition(
            position: Position(
                latitude: headQuarters.latitude,
                longitude: headQuarters.longitude)));
      }
      positionStream = geolocator.getPositionStream(locationOptions);
      subscription = positionStream.listen(
          (Position position) => add(UpdatePosition(position: position)));
    }
    if (event is UpdatePosition) {
      final Position position = event.position;
      yield PositionState.update(position: position);
      await _saveToDB(position: position);
    }
    if (event is StopListenForPosition) {
      await subscription?.cancel();
    }
  }

  Future<void> _saveToDB({Position position}) async {
    try {
      if (currentUserId == null) {
        return;
      }
      final GeoFirePoint myLocation =
          geo.point(latitude: position.latitude, longitude: position.longitude);
      final Map<String, dynamic> dataMap = <String, dynamic>{
        'isInNeed': false,
        'position': {
          'geohash': myLocation.hash,
          'geopoint': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          }
        },
      };
      await _firestore
          .collection('locations')
          .document(currentUserId)
          .setData(dataMap, merge: true);
    } catch (e) {
      print('Could not save position to firebase');
      print(e);
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
