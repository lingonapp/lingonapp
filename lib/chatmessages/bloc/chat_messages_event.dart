import 'package:equatable/equatable.dart';
import 'package:lingon/chatmessages/chat_message.dart';

abstract class ChatMessagesEvent extends Equatable {}

class FetchMessagesEvent extends ChatMessagesEvent {
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
  SendTextMessageEvent(this.text);
  final String text;
  @override
  List<Object> get props => [text];
}
