import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

@immutable
class PositionState extends Equatable {
  const PositionState({
    this.currentPosition,
  });
  factory PositionState.update({
    Position position,
  }) {
    return PositionState(
      currentPosition: position,
    );
  }

  final Position currentPosition;
}

class InitialPositionState extends PositionState {}
