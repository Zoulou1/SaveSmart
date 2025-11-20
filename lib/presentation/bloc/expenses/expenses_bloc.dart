import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savesmart/data/models/expense_model.dart';
import 'package:savesmart/data/repositories/expense_repository.dart';
import 'expenses_event.dart';
import 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final ExpenseRepository expenseRepository;
  StreamSubscription? _expensesSubscription;

  ExpensesBloc({required this.expenseRepository}) : super(ExpensesInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(ExpensesLoading());
    try {
      await _expensesSubscription?.cancel();
      _expensesSubscription = expenseRepository.getUserExpenses(event.userId).listen(
        (expenses) {
          emit(ExpensesLoaded(expenses));
        },
        onError: (error) {
          emit(ExpensesError(error.toString()));
        },
      );
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<ExpensesState> emit,
  ) async {
    try {
      final expense = ExpenseModel(
        id: '',
        userId: event.userId,
        category: event.category,
        amount: event.amount,
        description: event.description,
        date: event.date,
        source: event.source ?? 'manual',
      );
      await expenseRepository.createExpense(expense);
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpensesState> emit,
  ) async {
    try {
      await expenseRepository.updateExpense(event.expenseId, event.data);
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpensesState> emit,
  ) async {
    try {
      await expenseRepository.deleteExpense(event.expenseId);
    } catch (e) {
      emit(ExpensesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _expensesSubscription?.cancel();
    return super.close();
  }
}
