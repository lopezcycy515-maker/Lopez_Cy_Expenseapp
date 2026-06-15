import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
    this.createdAt,
  });

  final String id;
  final double amount;
  final String category;
  final String note;
  final DateTime date;
  final DateTime? createdAt;

  factory Expense.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Expense(
      id: doc.id,
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      category: data['category'] as String? ?? 'Other',
      note: data['note'] as String? ?? '',
      date: _readDate(data['date']),
      createdAt: _readDateOrNull(data['createdAt']),
    );
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  static DateTime? _readDateOrNull(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

const expenseCategories = [
  'Food',
  'Commute',
  'Rent',
  'Bills',
  'Others',
];
