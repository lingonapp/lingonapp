import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/app_tabs.dart';
import 'package:lingon/login/screens/loginscreen.dart';
import 'package:lingon/splash.dart';
import 'package:lingon/userModel.dart';

import 'auth/userrepository.dart';
import 'authentication/bloc.dart';
import 'blocdelegate.dart';
import 'currentuser/bloc/bloc.dart';

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
  final UserData _currentUser = UserData();

  AuthenticationBloc _authenticationBloc;
  CurrentUserBloc _currentUserBloc;

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
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
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
            _currentUserBloc = CurrentUserBloc(
                userRepository: _userRepository, userData: _currentUser);
            _currentUserBloc.dispatch(InitializeCurrentUser());
            return BlocProvider<CurrentUserBloc>(
              builder: (BuildContext context) => _currentUserBloc,
              child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
                bloc: _currentUserBloc,
                builder: (BuildContext context, CurrentUserState userState) {
                  if (userState == InitialCurrentUserState()) {
                    return SplashPage();
                  }
                  return AppTabs(
                    userRepository: _userRepository,
                    userData: userState.userData,
                  );
                },
              ),
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
