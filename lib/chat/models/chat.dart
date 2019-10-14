import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'chat.jser.dart';

@GenSerializer()
class ChatJsonSerializer extends Serializer<Chat> with _$ChatJsonSerializer {}

class Chat {
  Chat({
    this.id,
    this.latestMessage,
    this.userIds,
    this.userNames,
  });

  String id;
  LatestMessage latestMessage;
  List userIds;
  List userNames;
}

@GenSerializer()
class LatestMessageJsonSerializer extends Serializer<LatestMessage>
    with _$LatestMessageJsonSerializer {}

class LatestMessage {
  LatestMessage({this.from, this.text});

  // Timestamp createdAt;
  MessageAuthor from;
  String text;
}

@GenSerializer()
class MessageAuthorJsonSerializer extends Serializer<MessageAuthor>
    with _$MessageAuthorJsonSerializer {}

class MessageAuthor {
  MessageAuthor({this.name});

  String name;
}
