import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EntryActionsMenuWidget extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EntryActionsMenuWidget({
    Key? key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: CustomIconWidget(
        iconName: 'more_vert',
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      onSelected: (value) => _handleMenuAction(context, value),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Edit',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Share',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        onEdit();
        break;
      case 'share':
        _shareEntry(context);
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _shareEntry(BuildContext context) {
    final title = entry['title'] as String?;
    final body = entry['body'] as String? ?? '';
    final checklist = entry['checklist'] as List<dynamic>? ?? [];
    final date = _formatDate(entry['createdAt'] as String);

    String shareText = 'Journal Entry - $date\n\n';

    if (title != null && title.isNotEmpty) {
      shareText += 'Title: $title\n\n';
    }

    if (body.isNotEmpty) {
      shareText += 'Content:\n$body\n\n';
    }

    if (checklist.isNotEmpty) {
      shareText += 'Checklist:\n';
      for (var item in checklist) {
        final itemMap = item as Map<String, dynamic>;
        final isCompleted = itemMap['completed'] as bool? ?? false;
        final text = itemMap['text'] as String? ?? '';
        shareText += '${isCompleted ? '✓' : '○'} $text\n';
      }
      shareText += '\n';
    }

    shareText += 'Shared from My Growth Tracker';

    // Copy to clipboard as a simple share implementation
    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Entry copied to clipboard',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Entry',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this journal entry? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              ),
              child: Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onError,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return 'Unknown Date';
    }
  }
}
