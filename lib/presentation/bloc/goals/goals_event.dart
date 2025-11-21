import 'package:equatable/equatable.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoals extends GoalsEvent {
  final String userId;

  const LoadGoals(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddGoal extends GoalsEvent {
  final String userId;
  final String name;
  final double targetAmount;
  final DateTime deadline;
  final String? description;

  const AddGoal({
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.deadline,
    this.description,
  });

  @override
  List<Object?> get props => [userId, name, targetAmount, deadline, description];
}

class UpdateGoal extends GoalsEvent {
  final String goalId;
  final Map<String, dynamic> data;

  const UpdateGoal(this.goalId, this.data);

  @override
  List<Object?> get props => [goalId, data];
}

class DeleteGoal extends GoalsEvent {
  final String goalId;

  const DeleteGoal(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class AddToGoal extends GoalsEvent {
  final String goalId;
  final double amount;

  const AddToGoal(this.goalId, this.amount);

  @override
  List<Object?> get props => [goalId, amount];
}
