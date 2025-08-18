import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EditEntryFormWidget extends StatefulWidget {
  final Map<String, dynamic> entryData;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const EditEntryFormWidget({
    Key? key,
    required this.entryData,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<EditEntryFormWidget> createState() => _EditEntryFormWidgetState();
}

class _EditEntryFormWidgetState extends State<EditEntryFormWidget> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late DateTime _selectedDate;
  late List<Map<String, dynamic>> _checklistItems;
  bool _hasUnsavedChanges = false;
  int _wordCount = 0;
  int _originalWordCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _titleController =
        TextEditingController(text: widget.entryData['title'] ?? '');
    _bodyController =
        TextEditingController(text: widget.entryData['body'] ?? '');
    _selectedDate = DateTime.parse(
        widget.entryData['date'] ?? DateTime.now().toIso8601String());
    _checklistItems =
        List<Map<String, dynamic>>.from(widget.entryData['checklist'] ?? []);

    _originalWordCount = _countWords(widget.entryData['body'] ?? '');
    _wordCount = _originalWordCount;

    _titleController.addListener(_onTextChanged);
    _bodyController.addListener(_onBodyTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  void _onBodyTextChanged() {
    setState(() {
      _wordCount = _countWords(_bodyController.text);
      _hasUnsavedChanges = true;
    });
  }

  int _countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  void _addChecklistItem() {
    setState(() {
      _checklistItems.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': '',
        'completed': false,
      });
      _hasUnsavedChanges = true;
    });
  }

  void _removeChecklistItem(int index) {
    setState(() {
      _checklistItems.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  void _updateChecklistItem(int index, String text) {
    setState(() {
      _checklistItems[index]['text'] = text;
      _hasUnsavedChanges = true;
    });
  }

  void _toggleChecklistItem(int index) {
    setState(() {
      _checklistItems[index]['completed'] =
          !_checklistItems[index]['completed'];
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _hasUnsavedChanges = true;
      });
    }
  }

  void _saveEntry() {
    final updatedEntry = {
      ...widget.entryData,
      'title': _titleController.text.trim(),
      'body': _bodyController.text.trim(),
      'date': _selectedDate.toIso8601String(),
      'checklist': _checklistItems,
      'wordCount': _wordCount,
      'modifiedAt': DateTime.now().toIso8601String(),
    };

    widget.onSave(updatedEntry);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Selection
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: _selectDate,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                  ),
                  const Spacer(),
                  CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Title Field
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Entry Title (Optional)',
              hintText: 'What\'s on your mind today?',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'title',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
            maxLength: 100,
            textCapitalization: TextCapitalization.sentences,
          ),

          SizedBox(height: 3.h),

          // Body Text Field
          TextField(
            controller: _bodyController,
            decoration: InputDecoration(
              labelText: 'Your Thoughts',
              hintText: 'Share your reflections, experiences, and insights...',
              alignLabelWithHint: true,
            ),
            maxLines: 8,
            minLines: 6,
            maxLength: 5000,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
          ),

          SizedBox(height: 2.h),

          // Word Count Display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'text_fields',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Words: $_wordCount',
                  style: AppTheme.dataTextStyle(isLight: true, fontSize: 12),
                ),
                if (_wordCount != _originalWordCount) ...[
                  SizedBox(width: 2.w),
                  Text(
                    '(${_wordCount > _originalWordCount ? '+' : ''}${_wordCount - _originalWordCount})',
                    style: AppTheme.dataTextStyle(isLight: true, fontSize: 12)
                        .copyWith(
                      color: _wordCount > _originalWordCount
                          ? AppTheme.successLight
                          : AppTheme.errorLight,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Checklist Section
          Row(
            children: [
              Text(
                'Checklist Items',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addChecklistItem,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                label: Text('Add Item'),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Checklist Items
          if (_checklistItems.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'checklist',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'No checklist items yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(_checklistItems.length, (index) {
              final item = _checklistItems[index];
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: item['completed'] ?? false,
                      onChanged: (value) => _toggleChecklistItem(index),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter checklist item...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                        ),
                        controller:
                            TextEditingController(text: item['text'] ?? ''),
                        onChanged: (value) =>
                            _updateChecklistItem(index, value),
                        style: TextStyle(
                          decoration: (item['completed'] ?? false)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeChecklistItem(index),
                      icon: CustomIconWidget(
                        iconName: 'delete',
                        color: AppTheme.errorLight,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            }),

          SizedBox(height: 6.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _hasUnsavedChanges ? _saveEntry : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'save',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text('Save Changes'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
