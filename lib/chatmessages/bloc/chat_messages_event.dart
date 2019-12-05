import 'package:equatable/equatable.dart';
import 'package:lingon/chatmessages/chat_message.dart';

abstract class ChatMessagesEvent extends Equatable {}

class FetchMessagesEvent extends ChatMessagesEvent {
  FetchMessagesEvent(this.chatId);
  final String chatId;
  @override
  List<Object> get props => null;
}

class ReceivedMessagesEvent extends ChatMessagesEvent {
  ReceivedMessagesEvent(this.messages);
  final List<ChatMessage> messages;

  @override
  List<Object> get props => [messages];
}

class SendTextMessageEvent extends ChatMessagesEvent {
  SendTextMessageEvent(this.text, this.chatId);
  final String text;
  final String chatId;
  @override
  List<Object> get props => [text, chatId];
}

class FetchPreviousMessagesEvent extends ChatMessagesEvent {
  FetchPreviousMessagesEvent({ this.chatId, this.latestMessageId });
  final String chatId;
  final String latestMessageId;
  @override
  List<Object> get props => [chatId, latestMessageId];
}
