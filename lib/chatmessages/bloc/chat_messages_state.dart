import 'package:equatable/equatable.dart';
import 'package:lingon/chatmessages/chat_message.dart';

class ChatMessagesState extends Equatable {
  final Map<String, List<ChatMessage>> messages = Map();
  ChatMessagesState() : super();

  @override
  List<Object> get props => [props];
}

class InitialChatMessagesState extends ChatMessagesState {
  final Map<String, List<ChatMessage>> messages = Map();
  @override
  List<Object> get props => null;
}

class FetchingChatMessage extends ChatMessagesState {
  @override
  List<Object> get props => null;
}

class ChatMessagesFetched extends ChatMessagesState {
  final Map<String, List<ChatMessage>> messages;
  final bool isInitialFetch;
  ChatMessagesFetched({ this.messages, this.isInitialFetch}) : super();

  @override
  List<Object> get props => [messages, isInitialFetch];
}

class ChatMessageSending extends ChatMessagesState {
  @override
  List<Object> get props => null;
}

class ChatMessagesEnd extends ChatMessagesState {
  final Map<String, List<ChatMessage>> messages;
  final bool isInitialFetch;
  ChatMessagesEnd({ this.messages, this.isInitialFetch}) : super();
}

class FetchingPreviousChatMessage extends ChatMessagesState {
  @override
  List<Object> get props => null;
}
