import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/auth/userrepository.dart';

import 'app_tabs.dart';
import 'currentuser/bloc/bloc.dart';
import 'splash.dart';
import 'userModel.dart';

@immutable
class AuthenticatedApp extends StatelessWidget {
  AuthenticatedApp({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  final UserRepository _userRepository;
  final UserData _currentUser = UserData();

  @override
  Widget build(BuildContext context) {
    final CurrentUserBloc _currentUserBloc = CurrentUserBloc(
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
          return AppTabs();
        },
      ),
    );
    ;
  }
}
