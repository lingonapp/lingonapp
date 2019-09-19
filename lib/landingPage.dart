import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingon/app.dart';
import 'package:lingon/auth/auth.dart';
import 'package:lingon/auth/verifyAccount.dart';
import 'package:lingon/databaseService.dart';
import 'package:lingon/userModel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user == null) {
      return AuthPage();
    }
    if (!user.isEmailVerified) {
      return VerifyAccountPage();
    }
    return StreamProvider<UserData>.value(
      value: db.streamUser(user.uid),
      child: AppPage(),
      catchError: (BuildContext error, Object stackTrace) {
        print('inner: $error');
        print(stackTrace);
        if(user.uid != null) {
          db.createEmptyUser(userId: user.uid);
        }
        return UserData(
          id: null,
          public: PublicUserData(),
          private: PrivateUserData(),
        );
      },
    );
  }
}