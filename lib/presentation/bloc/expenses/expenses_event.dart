import 'package:equatable/equatable.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpensesEvent {
  final String userId;

  const LoadExpenses(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddExpense extends ExpensesEvent {
  final String userId;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final String? source;

  const AddExpense({
    required this.userId,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    this.source,
  });

  @override
  List<Object?> get props => [userId, category, amount, description, date, source];
}

class UpdateExpense extends ExpensesEvent {
  final String expenseId;
  final Map<String, dynamic> data;

  const UpdateExpense(this.expenseId, this.data);

  @override
  List<Object?> get props => [expenseId, data];
}

class DeleteExpense extends ExpensesEvent {
  final String expenseId;

  const DeleteExpense(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}
