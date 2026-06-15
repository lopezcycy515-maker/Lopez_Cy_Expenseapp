import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<SegmentedTabItem> tabs;

  @override
  Widget build(BuildContext context) {
    final isPhone = context.isPhone;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          margin: EdgeInsets.fromLTRB(
            context.horizontalPadding(),
            10,
            context.horizontalPadding(),
            0,
          ),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDecorations.radius),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x080F172A),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final selected = controller.index == index;
              final tab = tabs[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.animateTo(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.symmetric(
                      vertical: isPhone ? 10 : 11,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(AppDecorations.radius - 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          size: 16,
                          color:
                              selected ? Colors.white : AppColors.textSecondary,
                        ),
                        if (!isPhone) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              tab.label,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(width: 5),
                          Text(
                            tab.shortLabel ?? tab.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class SegmentedTabItem {
  const SegmentedTabItem({
    required this.label,
    required this.icon,
    this.shortLabel,
  });

  final String label;
  final String? shortLabel;
  final IconData icon;
}
