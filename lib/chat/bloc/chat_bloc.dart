import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
