import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalItemWidget extends StatelessWidget {
  final Map<String, dynamic> goal;
  final Function(bool) onToggle;
  final VoidCallback onRemove;

  const GoalItemWidget({
    Key? key,
    required this.goal,
    required this.onToggle,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = goal['completed'] ?? false;
    final customIcon = goal['icon'] as String?;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
        leading: GestureDetector(
          onTap: () => onToggle(!isCompleted),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.transparent,
              border: Border.all(
                color: isCompleted
                    ? Colors.green
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: isCompleted
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 4.w,
                  )
                : null,
          ),
        ),
        title: Row(
          children: [
            if (customIcon != null) ...[
              CustomIconWidget(
                iconName: customIcon,
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
            ],
            Expanded(
              child: Text(
                goal['text'] ?? '',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isCompleted
                      ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontWeight: isCompleted ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Remove Goal'),
                content: Text('Are you sure you want to remove this goal?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onRemove();
                    },
                    child: Text(
                      'Remove',
                      style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.error),
                    ),
                  ),
                ],
              ),
            );
          },
          icon: CustomIconWidget(
            iconName: 'delete',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
          tooltip: 'Remove goal',
        ),
      ),
    );
  }
}
