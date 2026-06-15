import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_auth_demo/theme/app_theme.dart';

void main() {
  test('AppTheme provides light theme', () {
    final theme = AppTheme.light();
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
  });
}
