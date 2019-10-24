import 'package:equatable/equatable.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:lingon/chat/models/chat.dart';

part 'chat_message.jser.dart';

abstract class ChatMessage extends Equatable {
  ChatMessage(this.timeStamp, this.type, this.from);

  final String timeStamp;
  final ChatMessageType type;
  final MessageAuthor from;
}

@GenSerializer(
  fields: {'type': EnDecode(processor: ChatMessageTypeProcessor())},
  ignore: ['props'],
)
class ChatTextMessageJsonSerializer extends Serializer<ChatTextMessage>
    with _$ChatTextMessageJsonSerializer {}

class ChatTextMessage extends ChatMessage {
  final String text;

  ChatTextMessage(String timeStamp, MessageAuthor from, this.text)
      : super(timeStamp, ChatMessageType.text, from);

  @override
  List<Object> get props => [timeStamp, type, from, text];
}

class ChatMessageType {
  const ChatMessageType._(this.value);

  final int value;

  static const ChatMessageType text = ChatMessageType._(1);
  static const ChatMessageType video = ChatMessageType._(2);

  @override
  String toString() {
    return value.toString();
  }
}

class ChatMessageTypeProcessor
    implements FieldProcessor<ChatMessageType, String> {
  const ChatMessageTypeProcessor();

  ChatMessageType deserialize(String input) {
    return ChatMessageType._(int.parse(input));
  }

  String serialize(ChatMessageType value) {
    return value.toString();
  }
}
