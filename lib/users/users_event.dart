import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class SetUsers extends UsersEvent {
  final Set users;
  SetUsers({this.users}) : super();

  @override
  List<Object> get props => [users];
}
