import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import '../theme/app_theme.dart';
import '../widgets/expense_dialog.dart';
import '../widgets/expense_list.dart';
import '../widgets/period_selector.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _expenseService = ExpenseService();
  late final TabController _tabController;
  late DateTime _selectedDay;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _selectedMonth = DateTime(now.year, now.month, 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  DateTime get _addExpenseDefaultDate {
    if (_tabController.index == 0) {
      final now = DateTime.now();
      return DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        now.hour,
        now.minute,
      );
    }
    final now = DateTime.now();
    if (_selectedMonth.year == now.year && _selectedMonth.month == now.month) {
      return now;
    }
    return DateTime(_selectedMonth.year, _selectedMonth.month, 1, 12);
  }

  Future<void> _addExpense() async {
    final result = await showExpenseDialog(
      context,
      initialDate: _addExpenseDefaultDate,
    );
    if (result == null || !mounted) return;
    await _expenseService.addExpense(
      amount: result.amount,
      category: result.category,
      date: result.date,
      note: result.note,
    );
  }

  Future<void> _editExpense(Expense expense) async {
    final result = await showExpenseDialog(context, expense: expense);
    if (result == null || !mounted) return;
    await _expenseService.updateExpense(
      docId: expense.id,
      amount: result.amount,
      category: result.category,
      date: result.date,
      note: result.note,
    );
  }

  Future<void> _deleteExpense(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppDecorations.borderRadius),
        title: const Text('Delete expense?'),
        content: Text('Remove "${expense.category}" from your records?'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _expenseService.deleteExpense(expense.id);
    }
  }

  String _monthLabel() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[_selectedMonth.month - 1]} ${_selectedMonth.year}';
  }

  String _userInitial(String email) {
    if (email.isEmpty) return '?';
    return email[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEC4899), AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'CyTracker',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => FirebaseAuth.instance.signOut(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  ),
                  if (email.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white24,
                            child: Text(
                              _userInitial(email),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              email,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: 'Daily'),
                          Tab(text: 'Monthly'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: [
                    DayPeriodSelector(
                      selectedDay: _selectedDay,
                      onDayChanged: (d) => setState(() => _selectedDay = d),
                    ),
                    Expanded(
                      child: _ExpenseTab(
                        stream: _expenseService.todayExpenses(_selectedDay),
                        title: 'Daily Total',
                        onEdit: _editExpense,
                        onDelete: _deleteExpense,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    MonthPeriodSelector(
                      selectedMonth: _selectedMonth,
                      onMonthChanged: (m) => setState(() => _selectedMonth = m),
                    ),
                    Expanded(
                      child: _ExpenseTab(
                        stream: _expenseService.monthExpenses(_selectedMonth),
                        title: 'Monthly Total',
                        subtitle: _monthLabel(),
                        onEdit: _editExpense,
                        onDelete: _deleteExpense,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppDecorations.borderRadiusSm,
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.primary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FilledButton.icon(
                onPressed: _addExpense,
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Expense'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 54),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseTab extends StatelessWidget {
  const _ExpenseTab({
    required this.stream,
    required this.title,
    required this.onEdit,
    required this.onDelete,
    this.subtitle,
  });

  final Stream<List<Expense>> stream;
  final String title;
  final String? subtitle;
  final void Function(Expense) onEdit;
  final void Function(Expense) onDelete;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final expenses = snapshot.data ?? [];
        return ExpenseList(
          expenses: expenses,
          emptyMessage: 'No expenses yet.\nTap New Expense to get started.',
          onEdit: onEdit,
          onDelete: onDelete,
          header: SummaryCard(
            title: title,
            subtitle: subtitle,
            total: totalAmount(expenses),
            count: expenses.length,
          ),
        );
      },
    );
  }
}
