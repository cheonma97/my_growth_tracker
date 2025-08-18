import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddGoalDialog extends StatefulWidget {
  final String title;
  final Function(String) onSubmit;

  const AddGoalDialog({
    Key? key,
    required this.title,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final TextEditingController _textController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isValid = _textController.text.trim().isNotEmpty;
    });
  }

  void _submit() {
    if (_isValid) {
      widget.onSubmit(_textController.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      surfaceTintColor: AppTheme.lightTheme.colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'add_task',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              widget.title,
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
        children: [
          TextField(
            controller: _textController,
            autofocus: true,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Enter your goal...',
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(4.w),
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            onSubmitted: (_) => _submit(),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Goals will automatically reset based on their time period.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isValid ? _submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            disabledForegroundColor:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Add Goal',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: _isValid
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
    );
  }
}
