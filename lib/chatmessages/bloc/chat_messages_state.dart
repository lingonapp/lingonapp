import 'package:equatable/equatable.dart';
import 'package:lingon/chatmessages/chat_message.dart';

class ChatMessagesState extends Equatable {
  ChatMessagesState([List props = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [props];
}

class InitialChatMessagesState extends ChatMessagesState {
  @override
  List<Object> get props => null;
}

class ChatMessagesFetched extends ChatMessagesState {
  final List<ChatMessage> messages;
  ChatMessagesFetched(this.messages) : super(messages);

  @override
  List<Object> get props => [messages];
}
