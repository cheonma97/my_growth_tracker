import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({Key? key}) : super(key: key);

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ExitConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      surfaceTintColor: AppTheme.lightTheme.colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      shadowColor: AppTheme.lightTheme.colorScheme.shadow,
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'exit_to_app',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Exit App',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to exit My Growth Tracker?',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Your journal entries are safely stored locally on your device.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          ),
          child: Text(
            'Cancel',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop(true);
            SystemNavigator.pop();
          },
          icon: CustomIconWidget(
            iconName: 'exit_to_app',
            color: Colors.white,
            size: 4.w,
          ),
          label: Text(
            'Exit',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
    );
  }
}
