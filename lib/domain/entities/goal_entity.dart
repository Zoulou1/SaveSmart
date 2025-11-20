import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final DateTime createdAt;
  final String? description;

  const GoalEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.createdAt,
    this.description,
  });

  double get progress => currentAmount / targetAmount;
  
  bool get isCompleted => currentAmount >= targetAmount;

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        targetAmount,
        currentAmount,
        deadline,
        createdAt,
        description,
      ];
}
