import 'package:equatable/equatable.dart';
import 'package:lingon/chat/models/chats.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatState extends Equatable {
  ChatState(this.chats);
  final Chats chats;
}

class InitialChatState extends ChatState {
  InitialChatState() : super(null);

  @override
  List<Object> get props => null;
}

class ChatsUpdated extends ChatState {
  ChatsUpdated(chats) : super(chats);

  @override
  List<Object> get props => [chats];
}
