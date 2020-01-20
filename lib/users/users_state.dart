import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lingon/users/HelpableUser.dart';

abstract class UsersState extends Equatable {
  const UsersState(this.users);
  final Set<HelpableUser> users;
}

class InitialUsersState extends UsersState {
  InitialUsersState() : super(null);

  @override
  List<Object> get props => [];
}

class UsersUpdated extends UsersState {
  UsersUpdated(Set<HelpableUser> users) : super(users);

  @override
  List<Object> get props => [users];
}
