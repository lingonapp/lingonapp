import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelpableUser {
  HelpableUser({ this.userId, this.name, this.position, this.distanceMeters = 0});
  final String userId;
  final String name;
  final LatLng position;
  final double distanceMeters;

  @override
  String toString() {
    return '${name} - ${userId}';
  }
}