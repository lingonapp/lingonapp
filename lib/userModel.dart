import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  UserData({this.id, this.isInNeed});

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data;
    return UserData(
      id: doc.documentID,
      isInNeed: data['isInNeed'],
    );
  }

  final String id;
  final bool isInNeed;

  Map<String, dynamic> serialize() {
    final Map<String, dynamic> dataMap = <String, dynamic>{
      'id': id,
      'name': 'unknown',
      'isInNeed': isInNeed,
    };
    return dataMap;
  }
}
