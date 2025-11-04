import 'package:flutter/material.dart';

import '../services/storage.dart';

class BudgetAddPage extends StatefulWidget {
  static const route = '/budget-add';
  const BudgetAddPage({super.key});

  @override
  State<BudgetAddPage> createState() => _BudgetAddPageState();
}

class _BudgetAddPageState extends State<BudgetAddPage> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    final items = await AppStorage.loadBudgets();
    items.add({
      'name': nameCtrl.text.trim(),
      'amount': double.tryParse(amountCtrl.text.trim()) ?? 0,
    });
    await AppStorage.saveBudgets(items);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Budget name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount (USD)'),
                keyboardType: TextInputType.number,
                validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter number' : null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: _save, child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}


