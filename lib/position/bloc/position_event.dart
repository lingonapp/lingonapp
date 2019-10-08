import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PositionEvent extends Equatable {
  const PositionEvent([List<dynamic> props = const <dynamic>[]]) : super();
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

  @override
  List<Object> get props => [position];
}

class ListenForPosition extends PositionEvent {
  ListenForPosition({@required this.currentUserId})
      : super(<String>[currentUserId]);
  final String currentUserId;

  @override
  String toString() {
    return 'Listening for position for user: ' + currentUserId;
  }

  @override
  List<Object> get props => [currentUserId];
}

class StopListenForPosition extends PositionEvent {
  @override
  List<Object> get props => null;
}
