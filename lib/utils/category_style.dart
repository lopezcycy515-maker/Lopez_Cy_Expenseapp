import 'package:flutter/material.dart';

class CategoryStyle {
  const CategoryStyle({required this.icon, required this.color, required this.bg});

  final IconData icon;
  final Color color;
  final Color bg;

  static CategoryStyle forCategory(String category) {
    return _map[category] ?? _map['Others']!;
  }

  static const _map = {
    'Food': CategoryStyle(
      icon: Icons.restaurant_rounded,
      color: Color(0xFFDB2777),
      bg: Color(0xFFFCE7F3),
    ),
    'Commute': CategoryStyle(
      icon: Icons.directions_car_filled_rounded,
      color: Color(0xFF7C3AED),
      bg: Color(0xFFEDE9FE),
    ),
    'Rent': CategoryStyle(
      icon: Icons.home_rounded,
      color: Color(0xFF2563EB),
      bg: Color(0xFFDBEAFE),
    ),
    'Bills': CategoryStyle(
      icon: Icons.receipt_long_rounded,
      color: Color(0xFFD97706),
      bg: Color(0xFFFEF3C7),
    ),
    'Others': CategoryStyle(
      icon: Icons.grid_view_rounded,
      color: Color(0xFF64748B),
      bg: Color(0xFFF1F5F9),
    ),
  };
}
