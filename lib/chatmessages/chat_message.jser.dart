// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ChatTextMessageJsonSerializer
    implements Serializer<ChatTextMessage> {
  Serializer<MessageAuthor> __messageAuthorJsonSerializer;
  Serializer<MessageAuthor> get _messageAuthorJsonSerializer =>
      __messageAuthorJsonSerializer ??= MessageAuthorJsonSerializer();
  @override
  Map<String, dynamic> toMap(ChatTextMessage model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'props',
        codeIterable(model.props, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'text', model.text);
    setMapValue(ret, 'timeStamp', model.timeStamp);
    setMapValue(ret, 'type', model.type);
    setMapValue(ret, 'from', _messageAuthorJsonSerializer.toMap(model.from));
    return ret;
  }

  @override
  ChatTextMessage fromMap(Map map) {
    if (map == null) return null;
    final obj = ChatTextMessage(
        map['timeStamp'] as String ?? getJserDefault('timeStamp'),
        map['type'] as int ?? getJserDefault('type'),
        _messageAuthorJsonSerializer.fromMap(map['from'] as Map) ??
            getJserDefault('from'),
        map['text'] as String ?? getJserDefault('text'));
    return obj;
  }
}
