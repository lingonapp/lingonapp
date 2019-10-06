import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserData {
  UserData({@required this.id, this.isInNeed = false});

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data;
    if (!doc.exists) {
      return UserData(
        id: doc.documentID,
      );
    }
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
