import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savesmart/domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.userId,
    required super.category,
    required super.amount,
    required super.description,
    required super.date,
    super.source,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      category: data['category'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      source: data['source'] ?? 'manual',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'category': category,
      'amount': amount,
      'description': description,
      'date': Timestamp.fromDate(date),
      'source': source,
    };
  }
}
