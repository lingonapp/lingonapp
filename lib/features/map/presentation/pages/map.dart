import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lingon/chat/screens/chat_screen.dart';
import 'package:lingon/currentuser/bloc/bloc.dart';
import 'package:lingon/databaseService.dart';
import 'package:lingon/features/map/presentation/widgets/help_user_modal.dart';
import 'package:lingon/loading/screens/loading_screen.dart';
import 'package:lingon/position/bloc/bloc.dart';
import 'package:lingon/settings/screens/settings_screen.dart';
import 'package:lingon/theme.dart';
import 'package:lingon/userModel.dart';
import 'package:lingon/users/HelpableUser.dart';
import 'package:lingon/users/bloc.dart';

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
  final PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (BuildContext context, CurrentUserState state) {
        final bool isInNeed = state.userData.isInNeed;
        final String userId = state.userData.id;
        final PositionBloc positionBloc =
            BlocProvider.of<PositionBloc>(context);
        positionBloc.add(ListenForPosition(currentUserId: userId));
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
            // _circles.add(userRadius);
          }
          var initialPosition = CameraPosition(
            target: LatLng(userPosition.latitude, userPosition.longitude),
            zoom: 14.4746,
          );
          return BlocBuilder<UsersBloc, UsersState>(
            builder: (BuildContext context, UsersState usersState) {
              try {
                _markers = usersState.users
                    .map((helpableUser) => Marker(
                          markerId: MarkerId(helpableUser.userId),
                          position: helpableUser.position,
                          onTap: () => _showHelpUserModal(helpableUser),
                        ))
                    .toSet();
              } catch (e) {
                _markers = Set();
              }
              return Scaffold(
                body: PageView(controller: pageController, children: [
                  SettingsScreen(),
                  Stack(children: [
                    GoogleMap(
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      ].toSet(),
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
                    Container(
                      margin: const EdgeInsets.only(top: 60, right: 20),
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          // Swipe right
                          pageController.animateToPage(2,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: Icon(Icons.chat),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 60, left: 20),
                      alignment: Alignment.topLeft,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          pageController.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: Icon(Icons.settings),
                      ),
                    ),
                  ]),
                  ChatScreen(),
                ]),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    _requestHelp(userData: state.userData, isInNeed: !isInNeed);
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

  void _showModal(Widget widget) {
    showModalBottomSheet<void>(
      barrierColor: Colors.pink[400].withAlpha(60),
      backgroundColor: Color.fromRGBO(255, 0, 0, 0),
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          color: Color.fromRGBO(0, 0, 0, 0),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 15.0, color: Colors.transparent),
                  borderRadius:
                  //TODO: Initiate chat here
                  const BorderRadius.all(Radius.circular(15)),
                  color: Color.fromRGBO(255, 255, 255, 0.95)),
              child: widget),
        );
      },
    ).whenComplete(() {
      print('Hey there, I\'m calling after hide bottomSheet');
    });
  }

  void _showHelpUserModal(HelpableUser userToHelp) {
    _showModal(HelpUserModal(userToHelp));
  }

  Future<void> _requestHelp({UserData userData, bool isInNeed}) async {
    final DatabaseService db = DatabaseService();
    await db.setInNeed(
        userId: userData.id, isInNeed: isInNeed, userName: userData.name);
  }
}
