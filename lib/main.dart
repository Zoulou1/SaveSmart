import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savesmart/core/theme/app_theme.dart';
import 'package:savesmart/data/repositories/auth_repository.dart';
import 'package:savesmart/data/repositories/goal_repository.dart';
import 'package:savesmart/data/repositories/expense_repository.dart';
import 'package:savesmart/data/repositories/user_repository.dart';
import 'package:savesmart/presentation/bloc/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:savesmart/presentation/bloc/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// lib/main.dart - CORRECTED MYAPP

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => GoalRepository()),
        RepositoryProvider(create: (context) => ExpenseRepository()),
      ],
      // 🚨 ADD THE AUTHBLOC PROVIDER HERE 🚨
      child: BlocProvider(
        create: (context) => AuthBloc(
          // AuthBloc depends on the repositories provided above
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
        ),
        child: MaterialApp(
          title: 'SaveSmart',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
