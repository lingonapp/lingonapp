import 'package:equatable/equatable.dart';
import 'package:lingon/userModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CurrentUserState extends Equatable {
  CurrentUserState([List props = const <dynamic>[]]) : super(props);
  UserData userData;
}

class InitialCurrentUserState extends CurrentUserState {}

class UpdateUser extends CurrentUserState {
  UpdateUser(this.userData) : super(<UserData>[userData]);
  final UserData userData;
}
