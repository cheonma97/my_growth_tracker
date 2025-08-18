import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './goal_item_widget.dart';

class GoalSectionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final List<Map<String, dynamic>> goals;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final Function(int, bool) onToggleGoal;
  final Function(int) onRemoveGoal;
  final VoidCallback onAddGoal;

  const GoalSectionWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.goals,
    required this.isExpanded,
    required this.onToggleExpansion,
    required this.onToggleGoal,
    required this.onRemoveGoal,
    required this.onAddGoal,
  }) : super(key: key);

  double _getCompletionPercentage() {
    if (goals.isEmpty) return 0.0;
    final completed = goals.where((goal) => goal['completed'] == true).length;
    return completed / goals.length;
  }

  @override
  Widget build(BuildContext context) {
    final completionPercentage = _getCompletionPercentage();
    final completedCount =
        goals.where((goal) => goal['completed'] == true).length;

    return Card(
      elevation: 2,
      shadowColor:
          AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggleExpansion,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: isExpanded ? Radius.zero : Radius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Progress indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: completionPercentage == 1.0
                              ? AppTheme.lightTheme.colorScheme.primaryContainer
                              : AppTheme.lightTheme.colorScheme
                                  .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$completedCount/${goals.length}',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: completionPercentage == 1.0
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),

                  // Progress bar
                  if (goals.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: completionPercentage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: completionPercentage == 1.0
                                ? Colors.green
                                : completionPercentage > 0.5
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.orange,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Content
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Column(
                    children: [
                      Divider(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        height: 1,
                      ),

                      // Goals list
                      if (goals.isNotEmpty) ...[
                        ...goals.asMap().entries.map((entry) {
                          final index = entry.key;
                          final goal = entry.value;
                          return GoalItemWidget(
                            goal: goal,
                            onToggle: (completed) =>
                                onToggleGoal(index, completed),
                            onRemove: () => onRemoveGoal(index),
                          );
                        }).toList(),
                      ] else ...[
                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            children: [
                              CustomIconWidget(
                                iconName: 'add_task',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 12.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No goals yet',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Add your first goal to get started!',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Add goal button
                      Padding(
                        padding: EdgeInsets.all(3.w),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: onAddGoal,
                            icon: CustomIconWidget(
                              iconName: 'add',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 5.w,
                            ),
                            label: Text('Add Goal'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                              side: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
