import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lingon/databaseService.dart';
import 'package:lingon/loading/screens/loading_screen.dart';
import 'package:lingon/position/bloc/bloc.dart';
import 'package:lingon/theme.dart';

import 'currentuser/bloc/bloc.dart';
import 'position/bloc/position_bloc.dart';
import 'users/bloc.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);
  @override
  State<MapPage> createState() => MapState();
}

class MapState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set();
  Geoflutterfire ageo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (BuildContext context, CurrentUserState state) {
        final bool isInNeed = state.userData.isInNeed;
        final String userId = state.userData.id;
        final PositionBloc positionBloc =
            BlocProvider.of<PositionBloc>(context);
        positionBloc.dispatch(ListenForPosition(currentUserId: userId));
        return BlocBuilder<PositionBloc, PositionState>(
            builder: (BuildContext context, PositionState postionState) {
          Position userPosition = postionState.currentPosition;
          if (userPosition == null) {
            return LoadingScreen();
          }
          if (userPosition != null) {
            Circle userRadius = Circle(
                circleId: CircleId('me'),
                center: LatLng(userPosition.latitude, userPosition.longitude),
                radius: 1500,
                strokeColor: lingonTheme.primaryColor,
                fillColor: lingonTheme.primaryColor.withOpacity(0.1));
            _circles.add(userRadius);
          }
          var initialPosition = CameraPosition(
            target: LatLng(userPosition.latitude, userPosition.longitude),
            zoom: 14.4746,
          );
          return BlocBuilder<UsersBloc, UsersState>(
            builder: (BuildContext context, UsersState usersState) {
              _markers = usersState.users;
              return Scaffold(
                body: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: initialPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: isInNeed,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers,
                  circles: _circles,
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    _requestHelp(
                        userId: state.userData.id, isInNeed: !isInNeed);
                  },
                  label: isInNeed
                      ? const Text('Disable')
                      : const Text('Request help'),
                  icon: isInNeed ? Icon(Icons.close) : Icon(Icons.check),
                ),
              );
            },
          );
        });
      },
    );
  }

  Future<void> _requestHelp({String userId, bool isInNeed}) async {
    final DatabaseService db = DatabaseService();
    await db.setInNeed(userId: userId, isInNeed: isInNeed);
  }
}
