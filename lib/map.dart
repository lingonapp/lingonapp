import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lingon/databaseService.dart';
import 'package:lingon/position/bloc/bloc.dart';

import 'currentuser/bloc/bloc.dart';
import 'position/bloc/position_bloc.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapState();
}

class MapState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition headQuarters = CameraPosition(
    target: LatLng(59.3225207, 18.0443221),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final PositionBloc positionBloc = BlocProvider.of<PositionBloc>(context);
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (BuildContext context, CurrentUserState state) {
        final bool isInNeed = state.userData.isInNeed;
        final String userId = state.userData.id;
        if (isInNeed) {
          positionBloc.dispatch(ListenForPosition(currentUserId: userId));
        }
        return Scaffold(
          body: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: headQuarters,
            myLocationEnabled: true,
            myLocationButtonEnabled: isInNeed,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _requestHelp(userId: state.userData.id, isInNeed: !isInNeed);
              if (!isInNeed) {
                positionBloc.dispatch(ListenForPosition(currentUserId: userId));
              } else {
                positionBloc.dispatch(StopListenForPosition());
              }
            },
            label:
                isInNeed ? const Text('Disable') : const Text('Request help'),
            icon: isInNeed ? Icon(Icons.close) : Icon(Icons.check),
          ),
        );
      },
    );
  }

  Future<void> _requestHelp({String userId, bool isInNeed}) async {
    final DatabaseService db = DatabaseService();
    await db.setInNeed(userId: userId, isInNeed: isInNeed);
  }
}
