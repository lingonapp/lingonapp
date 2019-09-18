import 'package:flutter/material.dart';
import 'package:lingon/auth/login.dart';
import 'package:lingon/auth/signup.dart';
import 'package:lingon/auth/verifyAccount.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'auth/login',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'auth/login':
            builder = (BuildContext context) => LoginPage();
            break;
          case 'auth/signup':
            builder = (BuildContext _) => SignUpPage();
            break;
          case 'auth/verify':
            builder = (BuildContext _) => VerifyAccountPage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      },
    );
  }
}
