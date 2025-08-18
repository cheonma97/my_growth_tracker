import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TitleInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const TitleInputWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title (Optional)',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            maxLength: 100,
            decoration: InputDecoration(
              hintText: 'Give your entry a title...',
              counterText: '${controller.text.length}/100',
              counterStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: controller.text.length > 80
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12),
                child: CustomIconWidget(
                  iconName: 'title',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            style: AppTheme.lightTheme.textTheme.bodyLarge,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
