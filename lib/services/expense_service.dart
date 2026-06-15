import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/expense.dart';

class ExpenseService {
  final _expensesRef = FirebaseFirestore.instance.collection('expenses');

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // Single-field query only — no composite index required.
  // Filter and sort by date on the client.
  Stream<List<Expense>> _myExpenses() {
    return _expensesRef
        .where('ownerId', isEqualTo: _uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(Expense.fromFirestore).toList(),
        );
  }

  Stream<List<Expense>> todayExpenses([DateTime? day]) {
    final target = day ?? DateTime.now();

    return _myExpenses().map((expenses) {
      final filtered = expenses
          .where((expense) => _isSameDay(expense.date, target))
          .toList();
      filtered.sort((a, b) => b.date.compareTo(a.date));
      return filtered;
    });
  }

  Stream<List<Expense>> monthExpenses([DateTime? month]) {
    final target = month ?? DateTime.now();

    return _myExpenses().map((expenses) {
      final filtered = expenses
          .where((expense) => _isSameMonth(expense.date, target))
          .toList();
      filtered.sort((a, b) => b.date.compareTo(a.date));
      return filtered;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  Future<void> addExpense({
    required double amount,
    required String category,
    required DateTime date,
    String note = '',
  }) {
    return _expensesRef.add({
      'amount': amount,
      'category': category,
      'note': note,
      'date': Timestamp.fromDate(date),
      'ownerId': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateExpense({
    required String docId,
    required double amount,
    required String category,
    required DateTime date,
    String note = '',
  }) {
    return _expensesRef.doc(docId).update({
      'amount': amount,
      'category': category,
      'note': note,
      'date': Timestamp.fromDate(date),
    });
  }

  Future<void> deleteExpense(String docId) {
    return _expensesRef.doc(docId).delete();
  }
}

Map<String, double> categoryTotals(List<Expense> expenses) {
  final totals = <String, double>{};
  for (final expense in expenses) {
    totals[expense.category] =
        (totals[expense.category] ?? 0) + expense.amount;
  }
  return totals;
}

double totalAmount(List<Expense> expenses) {
  return expenses.fold(0, (total, expense) => total + expense.amount);
}
