import 'package:flutter/material.dart';

import '../services/storage.dart';
import 'budget_add_page.dart';
import 'profile_edit_page.dart';
import 'tip_detail_page.dart';

class DashboardPage extends StatefulWidget {
  static const route = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SaveSmart')),
      body: IndexedStack(
        index: index,
        children: const [_GoalsTab(), _TipsTab(), _ProfileTab()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Tips',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _GoalsTab extends StatelessWidget {
  const _GoalsTab();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: AppStorage.loadBudgets(),
      builder: (context, snapshot) {
        final budgets = snapshot.data ?? [];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Total Savings',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$3,650',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...[
              _tx('Deposited to emergency fund', '+200.00'),
              _tx('Grocery Store', '-45.20'),
              _tx('Transfer to Vacation', '+150.00'),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Budgets',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () async {
                    final added = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BudgetAddPage()),
                    );
                    if (added == true) {
                      // Trigger refresh by rebuilding FutureBuilder
                      (context as Element).markNeedsBuild();
                    }
                  },
                  child: const Text('Add Budget'),
                ),
              ],
            ),
            if (budgets.isEmpty)
              const Text('No budgets yet')
            else
              ...budgets.map(
                (b) => ListTile(
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: Text(b['name']?.toString() ?? ''),
                  trailing: Text(
                    '\$${(b['amount'] as num).toStringAsFixed(2)}',
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  static Widget _tx(String title, String amount) {
    final isPositive = amount.startsWith('+');
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPositive ? Colors.green[50] : Colors.red[50],
        child: Icon(
          isPositive ? Icons.arrow_downward : Icons.arrow_upward,
          color: isPositive ? Colors.green : Colors.red,
        ),
      ),
      title: Text(title),
      trailing: Text(
        amount,
        style: TextStyle(
          color: isPositive ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TipsTab extends StatelessWidget {
  const _TipsTab();

  @override
  Widget build(BuildContext context) {
    final tips = const [
      (
        'Budgeting Basics',
        'Learn how to create and manage an effective budget',
      ),
      ('Saving Strategies', 'Discover effective ways to grow your savings'),
      ('Students Finance', 'Tips for managing your finances during college'),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tips.length,
      itemBuilder: (context, i) => Card(
        child: ListTile(
          leading: const Icon(Icons.lightbulb),
          title: Text(tips[i].$1),
          subtitle: Text(tips[i].$2),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TipDetailPage(title: tips[i].$1, body: tips[i].$2),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: AppStorage.loadProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data ?? {};
        final name = profile['name'] ?? 'Robert Smith';
        final email = profile['email'] ?? 'user@example.com';
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(name),
              subtitle: Text(email),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final changed = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                  );
                  if (changed == true) {
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Connected Account'),
              subtitle: Text('**** 1234'),
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Account Setting'),
            ),
            const ListTile(
              leading: Icon(Icons.history),
              title: Text('Transaction History'),
            ),
          ],
        );
      },
    );
  }
}
