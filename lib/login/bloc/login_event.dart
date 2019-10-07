import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent([List<String> props = const <String>[]]) : super();
}

class EmailChanged extends LoginEvent {
  EmailChanged({@required this.email}) : super(<String>[email]);
  final String email;

  @override
  String toString() => 'EmailChanged { email :$email }';

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginEvent {
  PasswordChanged({@required this.password}) : super(<String>[password]);
  final String password;

  @override
  String toString() => 'PasswordChanged { password: $password }';
  @override
  List<Object> get props => [password];
}

class Submitted extends LoginEvent {
  Submitted({@required this.email, @required this.password})
      : super(<String>[email, password]);
  final String email;
  final String password;

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }

  @override
  List<Object> get props => [email, password];
}

class LoginWithGooglePressed extends LoginEvent {
  @override
  String toString() => 'LoginWithGooglePressed';
  @override
  List<Object> get props => [null];
}

class LoginWithCredentialsPressed extends LoginEvent {
  LoginWithCredentialsPressed({@required this.email, @required this.password})
      : super(<String>[email, password]);
  final String email;
  final String password;

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }

  @override
  List<Object> get props => [email, password];
}
