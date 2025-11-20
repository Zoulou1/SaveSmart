import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savesmart/data/models/user_model.dart';
import 'package:savesmart/data/repositories/auth_repository.dart';
import 'package:savesmart/data/repositories/user_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  StreamSubscription? _authSubscription;

  AuthBloc({
    required this.authRepository,
    required this.userRepository,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    // on<AuthGoogleSignInRequested>(_onGoogleSignInRequested); 
    on<AuthSignOutRequested>(_onSignOutRequested);

    _authSubscription = authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(AuthCheckRequested());
      }
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(userCredential.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authRepository.signUpWithEmailAndPassword(
        event.email,
        event.password,
      );

      // Create user document in Firestore
      final userModel = UserModel(
        id: userCredential.user!.uid,
        email: event.email,
        name: event.name,
        phoneNumber: event.phoneNumber,
        createdAt: DateTime.now(),
      );
      await userRepository.createUser(userModel);

      emit(AuthAuthenticated(userCredential.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /* Google Sign-In logic is commented out.
  Future<void> _onGoogleSignInRequested(...) async {
     // ... logic commented out ...
  }
  */

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}