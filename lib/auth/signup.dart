import 'package:flutter/material.dart';
import 'package:lingon/auth/signupForm.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const Text('Sign up page'),
              SignUpForm(),
              GestureDetector(
                  child: const Text('Login page'),
                  onTap: () { Navigator.pushNamed(context, 'auth/login'); }
              )
            ],
          )
      ),
    );
  }
}
