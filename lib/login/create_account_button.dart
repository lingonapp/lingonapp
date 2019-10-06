import 'package:flutter/material.dart';
import 'package:lingon/auth/userrepository.dart';
import 'package:lingon/register/screens/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: const Text(
        'Create an Account',
      ),
      onPressed: () {
        Navigator.of(context).push<MaterialPageRoute>(
          MaterialPageRoute(builder: (BuildContext context) {
            return RegisterScreen(userRepository: _userRepository);
          }),
        );
      },
    );
  }
}
