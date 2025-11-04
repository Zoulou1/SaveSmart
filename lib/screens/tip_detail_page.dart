import 'package:flutter/material.dart';

class TipDetailPage extends StatelessWidget {
  static const route = '/tip';
  final String title;
  final String body;
  const TipDetailPage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(body, style: const TextStyle(fontSize: 16, height: 1.4)),
      ),
    );
  }
}


