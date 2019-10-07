import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent([List<String> props = const <String>[]]) : super();
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => null;
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';

  @override
  List<Object> get props => null;
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => null;
}

class UnverifiedEvent extends AuthenticationEvent {
  @override
  String toString() => 'UnverifiedEvent';

  @override
  List<Object> get props => null;
}
