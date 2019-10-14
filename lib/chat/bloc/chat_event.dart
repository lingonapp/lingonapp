import 'package:equatable/equatable.dart';
import 'package:lingon/chat/models/chats.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatEvent extends Equatable {
  const ChatEvent([List<dynamic> props = const <dynamic>[]]) : super();
}

class ListenForChats extends ChatEvent {
  ListenForChats({@required this.currentUserId})
      : super(<String>[currentUserId]);
  final String currentUserId;

  @override
  List<Object> get props => [currentUserId];
}

class UpdateChats extends ChatEvent {
  UpdateChats({this.chats}) : super(<Chats>[chats]);
  final Chats chats;

  @override
  List<Object> get props => [chats];
}
