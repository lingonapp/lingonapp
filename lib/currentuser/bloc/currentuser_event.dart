import 'package:equatable/equatable.dart';
import 'package:lingon/userModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CurrentUserEvent extends Equatable {
  const CurrentUserEvent([List<dynamic> props = const <dynamic>[]]) : super();
}

class InitializeCurrentUser extends CurrentUserEvent {
  @override
  List<Object> get props => null;
}

class UserUpdated extends CurrentUserEvent {
  UserUpdated(this.userData) : super(<UserData>[userData]);
  final UserData userData;

  @override
  String toString() => 'User updated: ' + userData.id;

  @override
  List<Object> get props => [userData];
}
