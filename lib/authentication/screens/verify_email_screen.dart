import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingon/theme.dart';

class VerifyEmail extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resendEmail() async {
    final FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          const Text('Please verify your email address'),
          FlatButton(
            color: lingonTheme.primaryColor,
            textColor: Colors.white,
            onPressed: () {
              _resendEmail();
            },
            child: const Text(
              'Resend email',
            ),
          )
        ])));
  }
}
