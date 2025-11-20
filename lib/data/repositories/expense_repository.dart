import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savesmart/data/models/expense_model.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'expenses';

  Future<String> createExpense(ExpenseModel expense) async {
    try {
      final docRef = await _firestore.collection(_collection).add(
            expense.toFirestore(),
          );
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ExpenseModel>> getUserExpenses(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromFirestore(doc))
            .toList());
  }

  Future<List<ExpenseModel>> getExpensesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateExpense(
      String expenseId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(expenseId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _firestore.collection(_collection).doc(expenseId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
