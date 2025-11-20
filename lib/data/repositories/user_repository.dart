import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savesmart/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(user.id).set(
            user.toFirestore(),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(userId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
