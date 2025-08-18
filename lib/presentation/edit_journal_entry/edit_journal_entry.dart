import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/edit_entry_form_widget.dart';

class EditJournalEntry extends StatefulWidget {
  const EditJournalEntry({Key? key}) : super(key: key);

  @override
  State<EditJournalEntry> createState() => _EditJournalEntryState();
}

class _EditJournalEntryState extends State<EditJournalEntry> {
  Map<String, dynamic>? _entryData;
  bool _isLoading = true;
  bool _hasUnsavedChanges = false;

  // Mock entry data - in real app this would come from SQLite database
  final Map<String, dynamic> _mockEntryData = {
    "id": "entry_001",
    "title": "Reflecting on Personal Growth",
    "body":
        """Today I spent some time thinking about my journey over the past few months. It's amazing how much can change when you commit to daily reflection and intentional growth.

I've been more mindful of my reactions to challenging situations, and I can see real progress in how I handle stress. The meditation practice I started three weeks ago is really paying off.

Key insights from today:
- Patience is a skill that improves with practice
- Small daily actions compound into significant changes
- Being kind to myself during setbacks is crucial

Tomorrow I want to focus on expressing gratitude more openly to the people who support me.""",
    "date": "2025-08-17T14:30:00.000Z",
    "createdAt": "2025-08-17T14:30:00.000Z",
    "modifiedAt": "2025-08-17T14:30:00.000Z",
    "wordCount": 127,
    "checklist": [
      {
        "id": "check_001",
        "text": "Practice morning meditation",
        "completed": true,
      },
      {
        "id": "check_002",
        "text": "Write in gratitude journal",
        "completed": true,
      },
      {
        "id": "check_003",
        "text": "Call mom to check in",
        "completed": false,
      },
      {
        "id": "check_004",
        "text": "Read 20 pages of personal development book",
        "completed": false,
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _loadEntryData();
  }

  void _loadEntryData() {
    // Simulate loading from database
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _entryData = Map<String, dynamic>.from(_mockEntryData);
        _isLoading = false;
      });
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Unsaved Changes'),
            content: Text(
                'You have unsaved changes. Are you sure you want to leave without saving?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Leave'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.errorLight,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _saveEntry(Map<String, dynamic> updatedEntry) {
    // In real app, this would save to SQLite database
    setState(() {
      _entryData = updatedEntry;
      _hasUnsavedChanges = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successLight,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Entry updated successfully'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back after short delay
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop(updatedEntry);
      }
    });
  }

  void _cancelEdit() async {
    if (_hasUnsavedChanges) {
      final shouldLeave = await _onWillPop();
      if (shouldLeave) {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Edit Entry'),
          leading: IconButton(
            onPressed: _cancelEdit,
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            if (_entryData != null)
              IconButton(
                onPressed:
                    _hasUnsavedChanges ? () => _saveEntry(_entryData!) : null,
                icon: CustomIconWidget(
                  iconName: 'save',
                  color: _hasUnsavedChanges
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                  size: 24,
                ),
              ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Loading entry...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              )
            : _entryData == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'error_outline',
                          color: AppTheme.errorLight,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Entry not found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'The entry you\'re trying to edit could not be loaded.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3.h),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Go Back'),
                        ),
                      ],
                    ),
                  )
                : EditEntryFormWidget(
                    entryData: _entryData!,
                    onSave: _saveEntry,
                    onCancel: _cancelEdit,
                  ),
        floatingActionButton: _entryData != null && _hasUnsavedChanges
            ? FloatingActionButton.extended(
                onPressed: () => _saveEntry(_entryData!),
                icon: CustomIconWidget(
                  iconName: 'save',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text('Save'),
                backgroundColor: AppTheme.lightTheme.primaryColor,
              )
            : null,
      ),
    );
  }
}
