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
    final UserData emptyUser = UserData(id: userId, isInNeed: false);
    return _db
        .collection('users')
        .document(userId)
        .setData(emptyUser.serialize());
  }

  Future<void> setInNeed({String userId, bool isInNeed}) async {
    final Map<String, dynamic> dataMap = <String, bool>{'isInNeed': isInNeed};
    return _db.collection('users').document(userId).updateData(dataMap);
  }

  Future<void> updateUser({String userId, String name, String photoUrl}) async {
    final DocumentSnapshot profileData =
        await _db.collection('users').document(userId).get();
    if (!profileData.exists) {
      print('Current google user has no profile data. Creating empty user');
      await createEmptyUser(userId: userId);
    }
    final Map<String, dynamic> dataMap = <String, String>{
      'name': name,
      'photoUrl': photoUrl
    };
    return _db
        .collection('users')
        .document(userId)
        .setData(dataMap, merge: true);
  }
}
