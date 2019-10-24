import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'chat.jser.dart';

@GenSerializer()
class ChatJsonSerializer extends Serializer<Chat> with _$ChatJsonSerializer {}

class Chat {
  Chat({
    this.latestMessage,
    this.userIds,
    this.userNames,
  });

  String _id;

  String get id => _id;

  set id(String id) {
    _id = id;
  }

  LatestMessage latestMessage;
  List userIds;
  List userNames;
}

@GenSerializer()
class LatestMessageJsonSerializer extends Serializer<LatestMessage>
    with _$LatestMessageJsonSerializer {}

class LatestMessage {
  LatestMessage({this.from, this.text});

  DateTime createdAt;
  MessageAuthor from;
  String text;
}

@GenSerializer()
class MessageAuthorJsonSerializer extends Serializer<MessageAuthor>
    with _$MessageAuthorJsonSerializer {}

class MessageAuthor {
  MessageAuthor({this.name, this.id});

  String name;
  String id;
}
