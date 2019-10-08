import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState([List<String> props = const <String>[]]) : super();
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';

  @override
  List<Object> get props => null;
}

class Authenticated extends AuthenticationState {
  Authenticated(this.displayName) : super(<String>[displayName]);
  final String displayName;

  @override
  String toString() => 'Authenticated { displayName: $displayName }';

  @override
  List<Object> get props => [displayName];
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';

  @override
  List<Object> get props => null;
}

class UnverifiedEmail extends AuthenticationState {
  @override
  String toString() => 'UnverifiedEmail';

  @override
  List<Object> get props => null;
}
