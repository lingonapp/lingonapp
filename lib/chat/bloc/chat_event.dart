import 'package:equatable/equatable.dart';
import 'package:lingon/chat/models/chats.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatEvent extends Equatable {
  const ChatEvent([List<dynamic> props = const <dynamic>[]]) : super();
}

class ListenForChats extends ChatEvent {
  @override
  List<Object> get props => null;
}

class UpdateChats extends ChatEvent {
  UpdateChats({this.chats}) : super(<Chats>[chats]);
  final Chats chats;

  @override
  List<Object> get props => [chats];
}
