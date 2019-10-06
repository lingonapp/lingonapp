import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent([List<String> props = const <String>[]]) : super(props);
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email}) : super(<String>[email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password}) : super(<String>[password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password})
      : super(<String>[email, password]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}
