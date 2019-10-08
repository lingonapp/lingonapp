import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class UsersState extends Equatable {
  const UsersState(this.users);
  final Set<Marker> users;
}

class InitialUsersState extends UsersState {
  InitialUsersState() : super(null);

  @override
  List<Object> get props => [];
}

class UsersUpdated extends UsersState {
  UsersUpdated(Set<Marker> users) : super(users);

  @override
  List<Object> get props => [users];
}
