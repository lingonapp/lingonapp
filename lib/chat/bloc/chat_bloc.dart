import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingon/chat/models/chat.dart';
import 'package:lingon/chat/models/chats.dart';

import './bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  @override
  ChatState get initialState => InitialChatState();

  StreamSubscription<Chats> subscription;
  final Firestore _firestore = Firestore.instance;

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ListenForChats) {
      var userId = event.currentUserId;
      void onChatsUpdate(Chats chats) {
        dispatch(UpdateChats(chats: chats));
      }

      await subscription?.cancel();
      subscription = streamChats(userId).listen(onChatsUpdate);
    }
    if (event is UpdateChats) {
      yield ChatsUpdated(event.chats);
    }
  }

  Stream<Chats> streamChats(String userId) {
    return _firestore
        .collection('chat')
        .where('userIds', arrayContains: userId)
        .snapshots()
        .map((QuerySnapshot snap) {
      final chatJsonSerializer = ChatJsonSerializer();
      List<Chat> map = snap.documents
          .map((DocumentSnapshot chatSnap) =>
              chatJsonSerializer.fromMap(chatSnap.data))
          .toList();
      return Chats(chats: map);
    });
  }
}
