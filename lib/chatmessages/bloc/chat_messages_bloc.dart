import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lingon/chat/models/chat.dart';
import 'package:lingon/chatmessages/ChatMessageRepository.dart';
import 'package:lingon/userModel.dart';

import '../chat_message.dart';
import 'bloc.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  ChatMessagesBloc(this.currentUserData);

  UserData currentUserData;

  StreamSubscription subscription;
  Map<String, StreamSubscription> messageSubscriptions = Map();
  ChatMessageRepository _chatMessageRepository = ChatMessageRepository();

  @override
  ChatMessagesState get initialState => InitialChatMessagesState();

  @override
  Stream<ChatMessagesState> mapEventToState(ChatMessagesEvent event) async* {
    if (event is FetchMessagesEvent) {
      String chatId = event.chatId;
      print('Get messages for $chatId');
      await messageSubscriptions[chatId]?.cancel();
      void onData(List<ChatMessage> chatMessages) {
        add(ReceivedMessagesEvent(chatMessages));
      }

      yield FetchingChatMessage();
      messageSubscriptions[chatId] =
          _chatMessageRepository.streamChatMessages(chatId).listen(onData);
    }
    if (event is ReceivedMessagesEvent) {
      yield ChatMessagesFetched(messages: event.messages, isInitialFetch: true);
    }
    if (event is SendTextMessageEvent) {
      String now = DateTime.now().toIso8601String();
      MessageAuthor from =
          MessageAuthor(name: currentUserData.name, id: currentUserData.id);
      ChatMessage message = ChatTextMessage(now, from, event.text);
      _chatMessageRepository.sendTextChatMessage(
          chatId: event.chatId, message: message);
    }
    if (event is FetchPreviousMessagesEvent) {
      // yield FetchingChatMessage();
      print(event.chatId);
      List<ChatMessage> previousMessages = await _chatMessageRepository
          .getPreviousMessages(event.chatId, event.latestMessageId);
      yield ChatMessagesFetched(
          messages: previousMessages, isInitialFetch: false);
    }
  }
}
