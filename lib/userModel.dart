import 'package:cloud_firestore/cloud_firestore.dart';

class PublicUserData {
  PublicUserData({this.name = ''});
  final String name;
}

class PrivateUserData {
  PrivateUserData({this.needsHelp = false });
  final bool needsHelp;
}

class UserData {
  UserData({ this.id, this.public, this.private });
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data;
    return UserData(
      id: doc.documentID,
      private: PrivateUserData(needsHelp: data['private']['needsHelp']) ?? PrivateUserData(needsHelp: false),
      public: PublicUserData(name: data['private']['name']) ?? PublicUserData(name: ''),
    );
  }
  final String id;
  final PublicUserData public;
  final PrivateUserData private;
}