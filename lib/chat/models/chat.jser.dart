// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ChatJsonSerializer implements Serializer<Chat> {
  Serializer<LatestMessage> __latestMessageJsonSerializer;
  Serializer<LatestMessage> get _latestMessageJsonSerializer =>
      __latestMessageJsonSerializer ??= LatestMessageJsonSerializer();
  @override
  Map<String, dynamic> toMap(Chat model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'latestMessage',
        _latestMessageJsonSerializer.toMap(model.latestMessage));
    setMapValue(ret, 'userIds',
        codeIterable(model.userIds, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'userNames',
        codeIterable(model.userNames, (val) => passProcessor.serialize(val)));
    return ret;
  }

  @override
  Chat fromMap(Map map) {
    if (map == null) return null;
    final obj = Chat();
    obj.id = map['id'] as String;
    obj.latestMessage =
        _latestMessageJsonSerializer.fromMap(map['latestMessage'] as Map);
    obj.userIds = codeIterable<dynamic>(
        map['userIds'] as Iterable, (val) => passProcessor.deserialize(val));
    obj.userNames = codeIterable<dynamic>(
        map['userNames'] as Iterable, (val) => passProcessor.deserialize(val));
    return obj;
  }
}

abstract class _$LatestMessageJsonSerializer
    implements Serializer<LatestMessage> {
  Serializer<MessageAuthor> __messageAuthorJsonSerializer;
  Serializer<MessageAuthor> get _messageAuthorJsonSerializer =>
      __messageAuthorJsonSerializer ??= MessageAuthorJsonSerializer();
  @override
  Map<String, dynamic> toMap(LatestMessage model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'createdAt', dateTimeUtcProcessor.serialize(model.createdAt));
    setMapValue(ret, 'from', _messageAuthorJsonSerializer.toMap(model.from));
    setMapValue(ret, 'text', model.text);
    return ret;
  }

  @override
  LatestMessage fromMap(Map map) {
    if (map == null) return null;
    final obj = LatestMessage();
    obj.createdAt =
        dateTimeUtcProcessor.deserialize(map['createdAt'] as String);
    obj.from = _messageAuthorJsonSerializer.fromMap(map['from'] as Map);
    obj.text = map['text'] as String;
    return obj;
  }
}

abstract class _$MessageAuthorJsonSerializer
    implements Serializer<MessageAuthor> {
  @override
  Map<String, dynamic> toMap(MessageAuthor model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'name', model.name);
    return ret;
  }

  @override
  MessageAuthor fromMap(Map map) {
    if (map == null) return null;
    final obj = MessageAuthor();
    obj.name = map['name'] as String;
    return obj;
  }
}
