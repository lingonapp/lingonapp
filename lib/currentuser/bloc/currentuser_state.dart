import 'package:equatable/equatable.dart';
import 'package:lingon/userModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CurrentUserState extends Equatable {
  const CurrentUserState(this.userData,
      [List<dynamic> props = const <dynamic>[]])
      : super(props);
  final UserData userData;
}

class InitialCurrentUserState extends CurrentUserState {
  const InitialCurrentUserState() : super(null);
}

class UpdateUser extends CurrentUserState {
  const UpdateUser(UserData userData) : super(userData);
}
