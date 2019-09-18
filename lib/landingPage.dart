import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingon/app.dart';
import 'package:lingon/auth/auth.dart';
import 'package:lingon/auth/verifyAccount.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final FirebaseUser user = snapshot.data;
          if (user == null) {
            return AuthPage();
          }
          if (!user.isEmailVerified) {
            return VerifyAccountPage();
          }
          return AppPage();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}