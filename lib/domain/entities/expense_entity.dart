import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final String? source; // 'manual', 'bank_card', 'mobile_money'

  const ExpenseEntity({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    this.source = 'manual',
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        category,
        amount,
        description,
        date,
        source,
      ];
}
