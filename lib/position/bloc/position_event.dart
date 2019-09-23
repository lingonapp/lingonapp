import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PositionEvent extends Equatable {
  const PositionEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class UpdatePosition extends PositionEvent {
  UpdatePosition({this.position}) : super(<Position>[position]);
  final Position position;

  @override
  String toString() {
    return '''UpdatePosition {
      $position
    }''';
  }
}

class ListenForPosition extends PositionEvent {
  ListenForPosition({@required this.currentUserId})
      : super(<String>[currentUserId]);
  final String currentUserId;

  @override
  String toString() {
    return 'Listening for position for user: ' + currentUserId;
  }
}

class StopListenForPosition extends PositionEvent {}
