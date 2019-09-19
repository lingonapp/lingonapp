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

  Future<void> setNeedsHelp({ String userId, bool needsHelp }) async {
    final Map<String, dynamic> dataMap = <String, bool>{
      'private.needsHelp': needsHelp
    };
    return _db
        .collection('users')
        .document(userId)
        .updateData(dataMap);
  }
}