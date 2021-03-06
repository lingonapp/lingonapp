import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lingon/position/bloc/bloc.dart';

import './bloc.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  Geoflutterfire geo = Geoflutterfire();
  final PositionBloc positionBloc;
  StreamSubscription positionBlocStream;
  StreamSubscription nearbyUsersStream;
  final Firestore _firestore = Firestore.instance;

  UsersBloc(this.positionBloc) {
    void onData(PositionState state) {
      Position position = state.currentPosition;
      if (position != null) {
        GeoFirePoint center = geo.point(
            latitude: position.latitude, longitude: position.longitude);
        CollectionReference collectionReference =
            _firestore.collection('locations');
        double radius = 1.5;
        String field = 'position';
        Stream<List<DocumentSnapshot>> stream = geo
            .collection(collectionRef: collectionReference)
            .within(field: field, center: center, radius: radius);
        nearbyUsersStream?.cancel();
        nearbyUsersStream =
            stream.listen((List<DocumentSnapshot> documentList) {
          Set<Marker> users = Set();
          documentList.forEach((element) {
            if (element.exists) {
              Map data = element.data;
              GeoPoint point = data['position']['geopoint'];
              String userName = data['name'];
              users.add(Marker(
                  infoWindow: InfoWindow(title: userName, snippet: '*'),
                  markerId: MarkerId(userName),
                  position: LatLng(point.latitude, point.longitude)));
            }
          });
          print(users.length);
          dispatch(SetUsers(users: users));
        });
      }
      ;
    }

    positionBlocStream = positionBloc.state.listen(onData);
  }

  @override
  UsersState get initialState => InitialUsersState();

  @override
  Stream<UsersState> mapEventToState(
    UsersEvent event,
  ) async* {
    if (event is SetUsers) {
      yield UsersUpdated(event.users);
    }
  }

  @override
  void dispose() {
    positionBlocStream?.cancel();
    nearbyUsersStream?.cancel();
    super.dispose();
  }
}
