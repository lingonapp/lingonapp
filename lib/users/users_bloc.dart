import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lingon/currentuser/bloc/bloc.dart';
import 'package:lingon/position/bloc/bloc.dart';

import './bloc.dart';
import 'HelpableUser.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  Geoflutterfire geo = Geoflutterfire();
  final PositionBloc positionBloc;
  final CurrentUserBloc currentUserBloc;
  StreamSubscription positionBlocStream;
  StreamSubscription nearbyUsersStream;
  final Firestore _firestore = Firestore.instance;

  UsersBloc(this.positionBloc, this.currentUserBloc) {
    void onData(PositionState state) {
      Position position = state.currentPosition;
      LatLng positionCoords = LatLng(position.latitude, position.longitude);
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
          Set<HelpableUser> users = Set();
          documentList.forEach((element) {
            if (element.exists) {
              Map data = element.data;
              GeoPoint point = data['position']['geopoint'];
              String userName = data['name'];
              if (userName == null) {
                return;
              }
              var loggedInUserId = currentUserBloc.state.userData.id;
              var helpableUserId = element.documentID;
              if (loggedInUserId == helpableUserId) {
                return;
              }
              LatLng userPos = LatLng(point.latitude, point.longitude);
              users.add(HelpableUser(
                  userId: helpableUserId,
                  name: userName,
                  distanceMeters:
                      calculateDistanceKm(userPos, positionCoords) * 1000,
                  position: userPos));
            }
          });
          print(users.length);
          add(SetUsers(users: users));
        });
      }
      ;
    }

    positionBlocStream = positionBloc.listen(onData);
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

  double calculateDistanceKm(LatLng p1, LatLng p2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((p2.latitude - p1.latitude) * p) / 2 +
        c(p1.latitude * p) *
            c(p2.latitude * p) *
            (1 - c((p2.longitude - p2.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Future<void> close() {
    positionBlocStream?.cancel();
    nearbyUsersStream?.cancel();
    return super.close();
  }
}
