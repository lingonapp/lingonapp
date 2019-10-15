import 'package:jaguar_serializer/jaguar_serializer.dart';

import 'chat.dart';

part 'chats.jser.dart';

@GenSerializer()
class ChatsJsonSerializer extends Serializer<Chats> with _$ChatsJsonSerializer {
}

class Chats {
  Chats({this.chats});
  List<Chat> chats;

  int get length => chats.length;
}
