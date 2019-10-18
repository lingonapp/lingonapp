import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingon/auth/userrepository.dart';
import 'package:lingon/chat/models/chat.dart';
import 'package:lingon/chat/models/chats.dart';

import './bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  StreamSubscription<Chats> subscription;
  final Firestore _firestore = Firestore.instance;
  final UserRepository userRepository;
  ChatBloc(this.userRepository);

  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ListenForChats) {
      void onChatsUpdate(Chats chats) {
        dispatch(UpdateChats(chats: chats));
      }

      await subscription?.cancel();
      String userId = await userRepository.getUserId();
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
        .limit(20)
        .snapshots()
        .map((QuerySnapshot snap) {
      final chatJsonSerializer = ChatJsonSerializer();
      List<Chat> map = snap.documents.map((DocumentSnapshot chatSnap) {
        Chat chat = chatJsonSerializer.fromMap(chatSnap.data);
        chat.id = chatSnap.documentID;
        return chat;
      }).toList();
      return Chats(chats: map);
    });
  }
}
