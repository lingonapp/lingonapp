import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lingon/chatmessages/ChatMessageRepository.dart';

import '../chat_message.dart';
import 'bloc.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  ChatMessagesBloc(this.chatId);
  String chatId;
  StreamSubscription subscription;
  ChatMessageRepository _chatMessageRepository = ChatMessageRepository();

  @override
  ChatMessagesState get initialState => InitialChatMessagesState();

  @override
  Stream<ChatMessagesState> mapEventToState(ChatMessagesEvent event) async* {
    if (event is FetchMessagesEvent) {
      print('Get messages for $chatId');
      await subscription?.cancel();
      void onData(List<ChatMessage> chatMessages) {
        dispatch(ReceivedMessagesEvent(chatMessages));
      }

      subscription =
          _chatMessageRepository.streamChatMessages(chatId).listen(onData);
    }
    if (event is ReceivedMessagesEvent) {
      yield ChatMessagesFetched(event.messages);
    }
  }
}
