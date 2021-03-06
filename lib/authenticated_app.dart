import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/auth/userrepository.dart';
import 'package:lingon/users/users_bloc.dart';

import 'app_tabs.dart';
import 'currentuser/bloc/bloc.dart';
import 'loading/screens/loading_screen.dart';
import 'position/bloc/bloc.dart';

@immutable
class AuthenticatedApp extends StatelessWidget {
  AuthenticatedApp({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  final UserRepository _userRepository;
  final PositionBloc _positionBloc = PositionBloc();

  @override
  Widget build(BuildContext context) {
    final UsersBloc _usersBloc = UsersBloc(_positionBloc);
    final CurrentUserBloc _currentUserBloc =
        CurrentUserBloc(userRepository: _userRepository);
    _currentUserBloc.dispatch(InitializeCurrentUser());
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentUserBloc>(
          builder: (BuildContext context) => _currentUserBloc,
        ),
        BlocProvider<PositionBloc>(
          builder: (BuildContext context) => _positionBloc,
        ),
        BlocProvider<UsersBloc>(
          builder: (BuildContext context) => _usersBloc,
        )
      ],
      child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
        bloc: _currentUserBloc,
        builder: (BuildContext context, CurrentUserState userState) {
          if (userState == InitialCurrentUserState()) {
            return LoadingScreen();
          }
          return AppTabs();
        },
      ),
    );
  }
}
