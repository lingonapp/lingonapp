import 'package:lingon/chat/models/chats.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatState {
  ChatState(this.chats);
  final Chats chats;
}

class InitialChatState extends ChatState {
  InitialChatState() : super(null);
}

class ChatsUpdated extends ChatState {
  ChatsUpdated(chats) : super(chats);
}
