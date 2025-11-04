import 'package:flutter/material.dart';

import 'register_page.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  static const route = '/welcome';
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  children: const [
                    Icon(Icons.savings, size: 120, color: Color(0xFF2E7D32)),
                    SizedBox(height: 24),
                    Text('Welcome to\nSaveSmart!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text(
                      'Set goals, track expenses, and build better financial habits',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, RegisterPage.route),
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, LoginPage.route),
                child: const Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


