import 'package:flutter/material.dart';

import 'register_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool obscured = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passwordCtrl,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(obscured ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => obscured = !obscured),
                    ),
                  ),
                  obscureText: obscured,
                  validator: (v) => (v != null && v.isNotEmpty) ? null : 'Required',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(context, DashboardPage.route);
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, RegisterPage.route),
                  child: const Text("Don't have an account? Sign up"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


