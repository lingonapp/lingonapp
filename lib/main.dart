import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/authentication/screens/verify_email_screen.dart';
import 'package:lingon/login/screens/loginscreen.dart';
import 'package:lingon/splash.dart';
import 'package:lingon/theme.dart';

import 'auth/userrepository.dart';
import 'authenticated_app.dart';
import 'authentication/bloc/bloc.dart';
import 'blocdelegate.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      builder: (BuildContext context) => _authenticationBloc,
      child: MaterialApp(
        title: 'Lingon',
        theme: lingonTheme,
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state == Uninitialized()) {
              return SplashPage();
            }
            if (state == Unauthenticated()) {
              return LoginScreen(userRepository: _userRepository);
            }

            if (state == UnverifiedEmail()) {
              return VerifyEmail();
            }
            return AuthenticatedApp(
              userRepository: _userRepository,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}
