import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  final TransitionLogger _transitionLogger = TransitionLogger();

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _transitionLogger.log(bloc, transition);
  }
}

class TransitionLogger {
  void log(Bloc bloc, Transition transition) {
    print(
        '''${ANSIColors.GREEN}TRANSITION${ANSIColors.RESET} => ${bloc.runtimeType} (
    currentState = ${transition.currentState}
    event = ${transition.event}
    nextState = ${transition.nextState}
)''');
  }
}

class ANSIColors {
  static const String GREEN = '\u001b[32m';
  static const String RESET = '\u001b[0m';
}
