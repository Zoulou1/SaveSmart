import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 🚨 Ensure these three imports are correct for your path:
import 'package:savesmart/presentation/bloc/auth/auth_bloc.dart';
import 'package:savesmart/presentation/bloc/auth/auth_state.dart';
import 'package:savesmart/presentation/bloc/auth/auth_event.dart'; 


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigateBasedOnState(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TestScreen(title: 'Home Screen (Authenticated)')),
      );
    } else if (state is AuthUnauthenticated || state is AuthError) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TestScreen(title: 'Login Screen (Unauthenticated)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // BlocListener watches the AuthBloc and triggers navigation
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _navigateBasedOnState(context, state);
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SaveSmart',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(), 
              SizedBox(height: 10),
              Text('Checking authentication status...'),
            ],
          ),
        ),
      ),
    );
  }
}


// --- TEMPORARY WIDGET FOR TESTING NAVIGATION (Delete later) ---
class TestScreen extends StatelessWidget {
  final String title;
  const TestScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}