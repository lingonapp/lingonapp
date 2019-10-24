import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserData {
  UserData({@required this.id, this.isInNeed = false, this.name});

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
      name: data['name'],
    );
  }

  final String id;
  final bool isInNeed;
  final String name;

  Map<String, dynamic> serialize() {
    final Map<String, dynamic> dataMap = <String, dynamic>{
      'id': id,
      'name': name,
      'isInNeed': isInNeed,
    };
    return dataMap;
  }
}
