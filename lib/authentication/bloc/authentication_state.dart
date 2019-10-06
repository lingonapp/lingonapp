import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState([List<String> props = const <String>[]])
      : super(props);
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  Authenticated(this.displayName) : super(<String>[displayName]);
  final String displayName;

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}

class UnverifiedEmail extends AuthenticationState {
  @override
  String toString() => 'UnverifiedEmail';
}
