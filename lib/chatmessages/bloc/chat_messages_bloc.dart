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
        add(ReceivedMessagesEvent(chatMessages, chatId));
      }

      yield FetchingChatMessage();
      bool hasMessages = await _chatMessageRepository.hasChatMessages(chatId);
      if (!hasMessages) {
        yield ChatMessagesEnd();
      }
      messageSubscriptions[chatId] =
          _chatMessageRepository.streamChatMessages(chatId).listen(onData);
    }
    if (event is ReceivedMessagesEvent) {
      final Map<String, List<ChatMessage>> messages = state.messages;
      if (messages[event.chatId] == null) {
        messages[event.chatId] = event.messages;
      } else {
        messages[event.chatId].addAll(event.messages);
      }
      print(messages);
      print('asd');
      yield ChatMessagesFetched(messages: messages, isInitialFetch: true);
    }
    if (event is SendTextMessageEvent) {
      yield ChatMessageSending();
      String now = DateTime.now().toIso8601String();
      MessageAuthor from =
          MessageAuthor(name: currentUserData.name, id: currentUserData.id);
      ChatMessage message = ChatTextMessage(now, from, event.text);
      _chatMessageRepository.sendTextChatMessage(
          chatId: event.chatId, message: message);
    }
    if (event is FetchPreviousMessagesEvent) {
      if (state is ChatMessagesEnd) {
        print('Cant fetch more since you are at the end');
        return;
      }
      List<ChatMessage> previousMessages = await _chatMessageRepository
          .getPreviousMessages(event.chatId, event.latestMessageId);
      final Map<String, List<ChatMessage>> messages = state.messages;
      if (messages[event.chatId] == null) {
        messages[event.chatId] = previousMessages;
      } else {
        messages[event.chatId].addAll(previousMessages);
      }
      if (previousMessages.length < 20) { // 20 = limit on fetch more, should be constant or remote config?
        yield ChatMessagesEnd(
            messages: messages, isInitialFetch: false
        );
      } else {
        yield ChatMessagesFetched(
            messages: messages, isInitialFetch: false);
      }
    }
  }
}
