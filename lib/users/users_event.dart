import 'package:equatable/equatable.dart';

import 'HelpableUser.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class SetUsers extends UsersEvent {
  final Set<HelpableUser> users;
  SetUsers({this.users}) : super();

  @override
  List<Object> get props => [users];
}
