import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/body_text_widget.dart';
import './widgets/checklist_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/save_button_widget.dart';
import './widgets/title_input_widget.dart';

class NewJournalEntry extends StatefulWidget {
  const NewJournalEntry({Key? key}) : super(key: key);

  @override
  State<NewJournalEntry> createState() => _NewJournalEntryState();
}

class _NewJournalEntryState extends State<NewJournalEntry> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _newItemController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _checklistItems = [];
  int _wordCount = 0;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  Timer? _autoSaveTimer;
  String? _draftId;

  @override
  void initState() {
    super.initState();
    _generateDraftId();
    _loadDraft();
    _setupAutoSave();

    // Add listeners for unsaved changes detection
    _titleController.addListener(_onContentChanged);
    _bodyController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.dispose();
    _bodyController.dispose();
    _newItemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _generateDraftId() {
    _draftId = 'draft_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _setupAutoSave() {
    _autoSaveTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_hasUnsavedChanges && _hasContent()) {
        _saveDraft();
      }
    });
  }

  void _onContentChanged() {
    setState(() {
      _wordCount = _calculateWordCount(_bodyController.text);
      _hasUnsavedChanges = true;
    });
  }

  int _calculateWordCount(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  bool _hasContent() {
    return _titleController.text.trim().isNotEmpty ||
        _bodyController.text.trim().isNotEmpty ||
        _checklistItems.isNotEmpty;
  }

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftData = prefs.getString('current_draft');

      if (draftData != null) {
        final draft = json.decode(draftData) as Map<String, dynamic>;

        setState(() {
          _titleController.text = draft['title'] as String? ?? '';
          _bodyController.text = draft['body'] as String? ?? '';
          _selectedDate = DateTime.parse(
              draft['date'] as String? ?? DateTime.now().toIso8601String());
          _checklistItems =
              (draft['checklist'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          _wordCount = _calculateWordCount(_bodyController.text);
        });
      }
    } catch (e) {
      // Silent fail - draft loading is not critical
    }
  }

  Future<void> _saveDraft() async {
    if (!_hasContent()) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final draftData = {
        'id': _draftId,
        'title': _titleController.text,
        'body': _bodyController.text,
        'date': _selectedDate.toIso8601String(),
        'checklist': _checklistItems,
        'lastModified': DateTime.now().toIso8601String(),
      };

      await prefs.setString('current_draft', json.encode(draftData));

      if (mounted) {
        Fluttertoast.showToast(
          msg: "Draft saved automatically",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          textColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        );
      }
    } catch (e) {
      // Silent fail - auto-save is not critical
    }
  }

  Future<void> _saveEntry() async {
    if (!_hasContent()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final entryId = 'entry_${DateTime.now().millisecondsSinceEpoch}';

      final entryData = {
        'id': entryId,
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
        'date': _selectedDate.toIso8601String(),
        'checklist': _checklistItems,
        'wordCount': _wordCount,
        'createdAt': DateTime.now().toIso8601String(),
        'modifiedAt': DateTime.now().toIso8601String(),
      };

      // Get existing entries
      final existingEntries = prefs.getStringList('journal_entries') ?? [];
      existingEntries.add(json.encode(entryData));

      // Save updated entries list
      await prefs.setStringList('journal_entries', existingEntries);

      // Clear current draft
      await prefs.remove('current_draft');

      setState(() {
        _hasUnsavedChanges = false;
        _isSaving = false;
      });

      Fluttertoast.showToast(
        msg: "Entry saved successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: Colors.white,
      );

      // Navigate back to main menu
      Navigator.pushNamedAndRemoveUntil(
          context, '/main-menu', (route) => false);
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      Fluttertoast.showToast(
        msg: "Failed to save entry. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
    }
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _hasUnsavedChanges = true;
    });
  }

  void _onTitleChanged(String value) {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  void _onBodyChanged(String value) {
    setState(() {
      _wordCount = _calculateWordCount(value);
      _hasUnsavedChanges = true;
    });
  }

  void _onChecklistItemToggled(int index, bool completed) {
    setState(() {
      _checklistItems[index]['completed'] = completed;
      _hasUnsavedChanges = true;
    });
  }

  void _onChecklistItemAdded(String text) {
    setState(() {
      _checklistItems.add({
        'text': text,
        'completed': false,
        'id': 'item_${DateTime.now().millisecondsSinceEpoch}',
      });
      _newItemController.clear();
      _hasUnsavedChanges = true;
    });
  }

  void _onChecklistItemRemoved(int index) {
    setState(() {
      _checklistItems.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Unsaved Changes',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Do you want to discard them?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Discard',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );

    return shouldDiscard ?? false;
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('New Entry'),
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            if (_hasUnsavedChanges)
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        body: GestureDetector(
          onTap: _dismissKeyboard,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 2.h),

                        // Date Picker
                        DatePickerWidget(
                          selectedDate: _selectedDate,
                          onDateChanged: _onDateChanged,
                        ),

                        SizedBox(height: 3.h),

                        // Title Input
                        TitleInputWidget(
                          controller: _titleController,
                          onChanged: _onTitleChanged,
                        ),

                        SizedBox(height: 3.h),

                        // Body Text
                        BodyTextWidget(
                          controller: _bodyController,
                          onChanged: _onBodyChanged,
                          wordCount: _wordCount,
                        ),

                        SizedBox(height: 3.h),

                        // Checklist
                        ChecklistWidget(
                          checklistItems: _checklistItems,
                          onItemToggled: _onChecklistItemToggled,
                          onItemAdded: _onChecklistItemAdded,
                          onItemRemoved: _onChecklistItemRemoved,
                          newItemController: _newItemController,
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),

                // Save Button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SaveButtonWidget(
                    isEnabled: _hasContent(),
                    onPressed: _saveEntry,
                    isSaving: _isSaving,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
