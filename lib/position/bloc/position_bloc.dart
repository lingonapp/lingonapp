import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

import './bloc.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  StreamSubscription<Position> subscription;
  Stream<Position> positionStream;
  GeolocationStatus geolocationStatus;
  Geolocator geolocator = Geolocator();
  final Firestore _firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  String currentUserId;

  @override
  PositionState get initialState => InitialPositionState();

  @override
  Stream<PositionState> mapEventToState(
    PositionEvent event,
  ) async* {
    if (event is ListenForPosition) {
      currentUserId = event.currentUserId;
      geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
      if (geolocationStatus == GeolocationStatus.denied) {
        return;
      }
      subscription?.cancel();
      positionStream = geolocator.getPositionStream(locationOptions);
      subscription = positionStream.listen(
          (Position position) => dispatch(UpdatePosition(position: position)));
    }
    if (event is UpdatePosition) {
      final Position position = event.position;
      yield PositionState.update(position: position);
      _saveToDB(position: position);
    }
    if (event is StopListenForPosition) {
      subscription?.cancel();
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
        'active': true,
        'position': myLocation.data,
      };
      _firestore
          .collection('locations')
          .document(currentUserId)
          .setData(dataMap, merge: true);
    } catch (e) {
      print('Could not save position to firebase');
      print(e);
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
