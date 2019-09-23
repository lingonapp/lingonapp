import 'package:equatable/equatable.dart';
import 'package:lingon/userModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CurrentUserEvent extends Equatable {
  const CurrentUserEvent([List<dynamic> props = const <dynamic>[]])
      : super(props);
}

class InitializeCurrentUser extends CurrentUserEvent {}

class UserUpdated extends CurrentUserEvent {
  UserUpdated(this.userData) : super(<UserData>[userData]);
  final UserData userData;

  @override
  String toString() => 'User updated: ' + userData.id;
}
