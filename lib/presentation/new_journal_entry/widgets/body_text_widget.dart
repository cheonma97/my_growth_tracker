import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BodyTextWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final int wordCount;

  const BodyTextWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.wordCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Thoughts',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$wordCount words',
                  style: AppTheme.dataTextStyle(isLight: true, fontSize: 11)
                      .copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            constraints: BoxConstraints(
              minHeight: 25.h,
              maxHeight: 35.h,
            ),
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText:
                    'What\'s on your mind today? Share your thoughts, experiences, and reflections...',
                hintMaxLines: 3,
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.all(4.w),
              ),
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    );
  }
}
