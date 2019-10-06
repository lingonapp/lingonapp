import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingon/auth/userrepository.dart';
import 'package:lingon/register/bloc/register_event.dart';
import 'package:lingon/register/bloc/register_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:validate/validate.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;
  final UserRepository _userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final Observable<RegisterEvent> observableStream = events;
    final Observable<RegisterEvent> nonDebounceStream =
        observableStream.where((RegisterEvent event) {
      return event is! EmailChanged && event is! PasswordChanged;
    });
    final Observable<RegisterEvent> debounceStream =
        observableStream.where((RegisterEvent event) {
      return event is EmailChanged || event is PasswordChanged;
    }).debounceTime(const Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    try {
      Validate.isEmail(email);
      yield currentState.update(
        isEmailValid: true,
      );
    } catch (e) {
      yield currentState.update(
        isEmailValid: false,
      );
    }
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: password.length > 6,
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield RegisterState.loading();
    try {
      FirebaseUser firebaseUser = await _userRepository.signUp(
        email: email,
        password: password,
      );
      await firebaseUser.sendEmailVerification();
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
