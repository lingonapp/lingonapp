import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingon/userModel.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<UserData> streamUser(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((DocumentSnapshot snap) => UserData.fromFirestore(snap));
  }

  Future<void> createEmptyUser({String userId}) async {
    final Map<String, dynamic> dataMap = <String, dynamic>{
      'private': <String, dynamic>{'isInNeed': false, 'friends': <String>[]},
      'public': <String, dynamic>{
        'name': '',
      }
    };
    return _db.collection('users').document(userId).setData(dataMap);
  }

  Future<void> setInNeed({String userId, bool isInNeed}) async {
    final Map<String, dynamic> dataMap = <String, bool>{
      'private.isInNeed': isInNeed
    };
    return _db.collection('users').document(userId).updateData(dataMap);
  }
}
