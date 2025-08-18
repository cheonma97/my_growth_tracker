import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateFilterWidget extends StatefulWidget {
  final Function(DateTime?, DateTime?) onDateRangeSelected;

  const DateFilterWidget({
    Key? key,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  State<DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends State<DateFilterWidget> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Text(
            'Filter by Date Range',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 3.h),

          // Start date picker
          _buildDatePickerTile(
            title: 'Start Date',
            selectedDate: _startDate,
            onDateSelected: (date) {
              setState(() {
                _startDate = date;
              });
            },
          ),

          SizedBox(height: 2.h),

          // End date picker
          _buildDatePickerTile(
            title: 'End Date',
            selectedDate: _endDate,
            onDateSelected: (date) {
              setState(() {
                _endDate = date;
              });
            },
          ),

          SizedBox(height: 4.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  child: Text('Clear'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Apply'),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildDatePickerTile({
    required String title,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () => _selectDate(onDateSelected),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  selectedDate != null
                      ? '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'
                      : 'Select date',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: selectedDate != null
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    widget.onDateRangeSelected(null, null);
    Navigator.pop(context);
  }

  void _applyFilters() {
    widget.onDateRangeSelected(_startDate, _endDate);
    Navigator.pop(context);
  }
}
