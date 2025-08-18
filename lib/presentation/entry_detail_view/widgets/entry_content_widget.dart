import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EntryContentWidget extends StatelessWidget {
  final Map<String, dynamic> entry;

  const EntryContentWidget({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = entry['title'] as String?;
    final body = entry['body'] as String? ?? '';
    final checklist = entry['checklist'] as List<dynamic>? ?? [];
    final wordCount = _calculateWordCount(body);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatDate(entry['createdAt'] as String),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 3.h),

          // Title Section (if present)
          title != null && title.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            SelectableText(
                              title,
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                )
              : const SizedBox.shrink(),

          // Body Content Section
          body.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Journal Entry',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SelectableText(
                              body,
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                )
              : const SizedBox.shrink(),

          // Checklist Section (if present)
          checklist.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Checklist',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            ...checklist.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value as Map<String, dynamic>;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 0.2.h),
                                      child: CustomIconWidget(
                                        iconName: (item['completed'] as bool? ??
                                                false)
                                            ? 'check_box'
                                            : 'check_box_outline_blank',
                                        color: (item['completed'] as bool? ??
                                                false)
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurfaceVariant,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: SelectableText(
                                        item['text'] as String? ?? '',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                          decoration:
                                              (item['completed'] as bool? ??
                                                      false)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                          decorationColor: AppTheme.lightTheme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                )
              : const SizedBox.shrink(),

          // Word Count Footer
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Word Count: $wordCount',
                  style: AppTheme.captionTextStyle(isLight: true),
                ),
                Text(
                  _formatTimestamp(entry['modifiedAt'] as String? ??
                      entry['createdAt'] as String),
                  style: AppTheme.captionTextStyle(isLight: true),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  int _calculateWordCount(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
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

  String _formatTimestamp(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}
