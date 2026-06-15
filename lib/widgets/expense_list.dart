import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_theme.dart';
import 'expense_card.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.emptyMessage,
    required this.onEdit,
    required this.onDelete,
    this.header,
  });

  final List<Expense> expenses;
  final String emptyMessage;
  final Widget? header;
  final void Function(Expense expense) onEdit;
  final void Function(Expense expense) onDelete;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty && header == null) {
      return _EmptyState(message: emptyMessage);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: (header != null ? 1 : 0) +
          expenses.length +
          (expenses.isEmpty ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (header != null && index == 0) return header!;

        final offset = header != null ? 1 : 0;

        if (expenses.isEmpty && index == offset) {
          return _EmptyState(message: emptyMessage);
        }

        final expense = expenses[index - offset];
        return ExpenseCard(
          expense: expense,
          onEdit: () => onEdit(expense),
          onDelete: () => onDelete(expense),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
