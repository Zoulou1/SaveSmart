import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savesmart/data/models/goal_model.dart';

class GoalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'goals';

  Future<String> createGoal(GoalModel goal) async {
    try {
      final docRef = await _firestore.collection(_collection).add(
            goal.toFirestore(),
          );
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<GoalModel>> getUserGoals(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GoalModel.fromFirestore(doc)).toList());
  }

  Future<void> updateGoal(String goalId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(goalId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _firestore.collection(_collection).doc(goalId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToGoal(String goalId, double amount) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final goalDoc =
            await transaction.get(_firestore.collection(_collection).doc(goalId));
        final currentAmount = (goalDoc.data()?['currentAmount'] ?? 0).toDouble();
        transaction.update(
          goalDoc.reference,
          {'currentAmount': currentAmount + amount},
        );
      });
    } catch (e) {
      rethrow;
    }
  }
}
