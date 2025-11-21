import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savesmart/data/models/goal_model.dart';
import 'package:savesmart/data/repositories/goal_repository.dart';
import 'goals_event.dart';
import 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final GoalRepository goalRepository;
  StreamSubscription? _goalsSubscription;

  GoalsBloc({required this.goalRepository}) : super(GoalsInitial()) {
    on<LoadGoals>(_onLoadGoals);
    on<AddGoal>(_onAddGoal);
    on<UpdateGoal>(_onUpdateGoal);
    on<DeleteGoal>(_onDeleteGoal);
    on<AddToGoal>(_onAddToGoal);
  }

  Future<void> _onLoadGoals(
    LoadGoals event,
    Emitter<GoalsState> emit,
  ) async {
    emit(GoalsLoading());
    try {
      await _goalsSubscription?.cancel();
      _goalsSubscription = goalRepository.getUserGoals(event.userId).listen(
        (goals) {
          add(const _GoalsUpdated());
          emit(GoalsLoaded(goals));
        },
        onError: (error) {
          emit(GoalsError(error.toString()));
        },
      );
    } catch (e) {
      emit(GoalsError(e.toString()));
    }
  }

  Future<void> _onAddGoal(
    AddGoal event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      final goal = GoalModel(
        id: '',
        userId: event.userId,
        name: event.name,
        targetAmount: event.targetAmount,
        currentAmount: 0,
        deadline: event.deadline,
        createdAt: DateTime.now(),
        description: event.description,
      );
      await goalRepository.createGoal(goal);
    } catch (e) {
      emit(GoalsError(e.toString()));
    }
  }

  Future<void> _onUpdateGoal(
    UpdateGoal event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      await goalRepository.updateGoal(event.goalId, event.data);
    } catch (e) {
      emit(GoalsError(e.toString()));
    }
  }

  Future<void> _onDeleteGoal(
    DeleteGoal event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      await goalRepository.deleteGoal(event.goalId);
    } catch (e) {
      emit(GoalsError(e.toString()));
    }
  }

  Future<void> _onAddToGoal(
    AddToGoal event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      await goalRepository.addToGoal(event.goalId, event.amount);
    } catch (e) {
      emit(GoalsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _goalsSubscription?.cancel();
    return super.close();
  }
}

// Internal event for stream updates
class _GoalsUpdated extends GoalsEvent {
  const _GoalsUpdated();
}
