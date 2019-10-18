// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ChatsJsonSerializer implements Serializer<Chats> {
  Serializer<Chat> __chatJsonSerializer;
  Serializer<Chat> get _chatJsonSerializer =>
      __chatJsonSerializer ??= ChatJsonSerializer();
  @override
  Map<String, dynamic> toMap(Chats model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'length', model.length);
    setMapValue(
        ret,
        'chats',
        codeIterable(
            model.chats, (val) => _chatJsonSerializer.toMap(val as Chat)));
    return ret;
  }

  @override
  Chats fromMap(Map map) {
    if (map == null) return null;
    final obj = Chats();
    obj.chats = codeIterable<Chat>(map['chats'] as Iterable,
        (val) => _chatJsonSerializer.fromMap(val as Map));
    return obj;
  }
}
