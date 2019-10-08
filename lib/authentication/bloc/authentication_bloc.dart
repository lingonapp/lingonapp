import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lingon/auth/userrepository.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;
  final UserRepository _userRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is UnverifiedEvent) {
      yield* _mapUnverifiedToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final bool isSignedIn = await _userRepository.isSignedIn();
      final bool isVerified = await _userRepository.isEmailVerified();
      if (!isVerified) {
        yield UnverifiedEmail();
      } else if (isSignedIn) {
        final String name = await _userRepository.getUserEmail();
        yield Authenticated(name);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    if (await _userRepository.isEmailVerified()) {
      yield Authenticated(await _userRepository.getUserEmail());
    } else {
      dispatch(UnverifiedEvent());
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    await _userRepository.signOut();
  }

  Stream<AuthenticationState> _mapUnverifiedToState() async* {
    yield UnverifiedEmail();
  }

  @override
  AuthenticationState get initialState => Uninitialized();
}
