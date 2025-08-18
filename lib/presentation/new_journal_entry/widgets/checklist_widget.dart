import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChecklistWidget extends StatelessWidget {
  final List<Map<String, dynamic>> checklistItems;
  final Function(int, bool) onItemToggled;
  final Function(String) onItemAdded;
  final Function(int) onItemRemoved;
  final TextEditingController newItemController;

  const ChecklistWidget({
    Key? key,
    required this.checklistItems,
    required this.onItemToggled,
    required this.onItemAdded,
    required this.onItemRemoved,
    required this.newItemController,
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
                'Tasks & Goals',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              if (checklistItems.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${checklistItems.where((item) => item['completed'] == true).length}/${checklistItems.length}',
                    style: AppTheme.dataTextStyle(isLight: true, fontSize: 11)
                        .copyWith(
                      color:
                          AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),

          // Add new item input
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: newItemController,
                    decoration: InputDecoration(
                      hintText: 'Add a task or goal...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.5.h),
                    ),
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textCapitalization: TextCapitalization.sentences,
                    onFieldSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        onItemAdded(value.trim());
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (newItemController.text.trim().isNotEmpty) {
                      onItemAdded(newItemController.text.trim());
                    }
                  },
                  icon: CustomIconWidget(
                    iconName: 'add_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          if (checklistItems.isNotEmpty) ...[
            SizedBox(height: 2.h),

            // Checklist items
            Container(
              constraints: BoxConstraints(maxHeight: 20.h),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: checklistItems.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  final item = checklistItems[index];
                  final isCompleted = item['completed'] as bool;

                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => onItemToggled(index, !isCompleted),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : Colors.transparent,
                              border: Border.all(
                                color: isCompleted
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isCompleted
                                ? CustomIconWidget(
                                    iconName: 'check',
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            item['text'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => onItemRemoved(index),
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 18,
                          ),
                          constraints:
                              BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
