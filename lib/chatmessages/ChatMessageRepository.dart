import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_message.dart';

class ChatMessageRepository {
  final Firestore _firestore = Firestore.instance;

  Stream<List<ChatMessage>> streamChatMessages(String chatId) {
    return _firestore
        .collection('chat')
        .document(chatId)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .limit(20)
        .snapshots()
        .map((QuerySnapshot snap) {
      List<ChatMessage> map = snap.documents
          .map((DocumentSnapshot chatSnap) =>
              ChatTextMessageJsonSerializer().fromMap(chatSnap.data))
          .toList();
      print('chatid');
      print(chatId);
      return map;
    });
  }

  void sendTextChatMessage({String chatId, ChatTextMessage message}) {
    DocumentReference chatDocRef =
        _firestore.collection('chat').document(chatId);
    CollectionReference messagesCollection = chatDocRef.collection('messages');
    Map<String, dynamic> x = ChatTextMessageJsonSerializer().toMap(message);
    messagesCollection.add(x);
  }
}
