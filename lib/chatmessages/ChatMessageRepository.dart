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
      List<ChatMessage> map = snap.documents.map((DocumentSnapshot chatSnap) {
        ChatTextMessage chat =
            ChatTextMessageJsonSerializer().fromMap(chatSnap.data);
        chat.id = chatSnap.documentID;
        return chat;
      }).toList();
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

  Future<List<ChatTextMessage>> getPreviousMessages(
      String chatId, String prevMessageId) async {
    DocumentReference chatDocRef =
        _firestore.collection('chat').document(chatId);
    CollectionReference messagesCollection = chatDocRef.collection('messages');
    DocumentSnapshot prevDocument;
    prevDocument = await messagesCollection
        .document(prevMessageId)
        ?.get(); // gets a reference to the last message in the existing list
    final querySnapshot = await messagesCollection
        .startAfterDocument(
            prevDocument) // Start reading documents after the specified document
        .orderBy('timeStamp', descending: true) // order them by timestamp
        .limit(20) // limit the read to 20 items
        .getDocuments();
    List<ChatTextMessage> messageList = List();
    querySnapshot.documents.forEach((doc) {
      ChatTextMessage chatMessage = ChatTextMessageJsonSerializer().fromMap(doc.data);
      chatMessage.id = doc.documentID;
      messageList.add(chatMessage);
    });
    return messageList;
  }
}
