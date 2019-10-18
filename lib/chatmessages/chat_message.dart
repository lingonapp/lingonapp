import 'package:equatable/equatable.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:lingon/chat/models/chat.dart';

part 'chat_message.jser.dart';

abstract class ChatMessage extends Equatable {
  ChatMessage(this.timeStamp, this.type, this.from);

  final String timeStamp;
  final int type;
  final MessageAuthor from;
}

@GenSerializer()
class ChatTextMessageJsonSerializer extends Serializer<ChatTextMessage>
    with _$ChatTextMessageJsonSerializer {}

class ChatTextMessage extends ChatMessage {
  final String text;

  ChatTextMessage(String timeStamp, int type, MessageAuthor from, this.text)
      : super(timeStamp, type, from);

  @override
  List<Object> get props => [timeStamp, type, from, text];
}
