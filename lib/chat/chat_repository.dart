import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final Firestore _firestore = Firestore.instance;

  void startChat(List<String> otherUsers, String currentUserId) async {
    List usersInChat = [currentUserId];
    usersInChat.addAll(otherUsers);
    print(usersInChat);
    var chatDocRef =
      _firestore.collection('chats').where("userIds", whereIn: usersInChat);
    var foundChats = await chatDocRef.getDocuments();
    if (foundChats.documents.isNotEmpty) {
      print('Go to already created chat');
    }
    Map<String, dynamic> data = {
      'userIds': usersInChat,
    };
    // await _firestore.collection('chats').document().setData(data);
    // TODO: Navigate to chat
  }
}
