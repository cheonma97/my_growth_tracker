import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SaveButtonWidget extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final bool isSaving;

  const SaveButtonWidget({
    Key? key,
    required this.isEnabled,
    required this.onPressed,
    this.isSaving = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 6.h,
      margin: EdgeInsets.only(bottom: 2.h),
      child: ElevatedButton(
        onPressed: isEnabled && !isSaving ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          foregroundColor: isEnabled
              ? Colors.white
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          elevation: isEnabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSaving
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Saving...',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'save',
                    color: isEnabled
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Save Entry',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: isEnabled
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
