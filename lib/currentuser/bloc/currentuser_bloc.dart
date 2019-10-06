import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lingon/auth/userrepository.dart';
import 'package:lingon/databaseService.dart';
import 'package:lingon/userModel.dart';

import './bloc.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  CurrentUserBloc({this.userRepository});

  final UserRepository userRepository;
  StreamSubscription<UserData> subscription;

  @override
  CurrentUserState get initialState => InitialCurrentUserState();

  @override
  Stream<CurrentUserState> mapEventToState(
    CurrentUserEvent event,
  ) async* {
    if (event is InitializeCurrentUser) {
      final String userId = await userRepository.getUserId();
      subscription?.cancel();
      subscription = DatabaseService()
          .streamUser(userId)
          .listen((UserData user) => dispatch(UserUpdated(user)));
    }
    if (event is UserUpdated) {
      yield UpdateUser(event.userData);
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
