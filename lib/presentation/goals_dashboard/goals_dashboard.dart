import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_goal_dialog.dart';
import './widgets/goal_section_widget.dart';

class GoalsDashboard extends StatefulWidget {
  const GoalsDashboard({Key? key}) : super(key: key);

  @override
  State<GoalsDashboard> createState() => _GoalsDashboardState();
}

class _GoalsDashboardState extends State<GoalsDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Map<String, List<Map<String, dynamic>>> _allGoals = {
    'today': [],
    'weekly': [],
    'monthly': [],
    'yearly': [],
    'daily': [],
  };

  Map<String, bool> _sectionExpanded = {
    'today': true,
    'weekly': true,
    'monthly': true,
    'yearly': true,
    'daily': true,
  };

  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadGoals();
    _initializeDailyGoals();
    _setupResetTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resetTimer?.cancel();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  void _setupResetTimer() {
    _resetTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkAndResetGoals();
    });
  }

  Future<void> _loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      for (String category in _allGoals.keys) {
        final goalsJson = prefs.getString('goals_$category') ?? '[]';
        final goals = (json.decode(goalsJson) as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        setState(() {
          _allGoals[category] = goals;
        });
      }

      await _checkAndResetGoals();
    } catch (e) {
      // Silent fail for loading
    }
  }

  Future<void> _initializeDailyGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dailyGoalsJson = prefs.getString('goals_daily') ?? '[]';
      final existingGoals = json.decode(dailyGoalsJson) as List;

      if (existingGoals.isEmpty) {
        final defaultDailyGoals = [
          {
            'id': 'daily_meditation_${DateTime.now().millisecondsSinceEpoch}',
            'text': '15 min meditation',
            'completed': false,
            'icon': 'self_improvement',
            'createdAt': DateTime.now().toIso8601String(),
            'lastReset': DateTime.now().toIso8601String(),
          },
          {
            'id': 'daily_workout_${DateTime.now().millisecondsSinceEpoch + 1}',
            'text': '30 min workout',
            'completed': false,
            'icon': 'fitness_center',
            'createdAt': DateTime.now().toIso8601String(),
            'lastReset': DateTime.now().toIso8601String(),
          },
          {
            'id': 'daily_learn_${DateTime.now().millisecondsSinceEpoch + 2}',
            'text': '1 hour skill learn',
            'completed': false,
            'icon': 'school',
            'createdAt': DateTime.now().toIso8601String(),
            'lastReset': DateTime.now().toIso8601String(),
          },
        ];

        await _saveGoals('daily', defaultDailyGoals);

        setState(() {
          _allGoals['daily'] = defaultDailyGoals;
        });
      }
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _checkAndResetGoals() async {
    try {
      final now = DateTime.now();
      bool needsSave = false;

      for (String category in _allGoals.keys) {
        final goals = _allGoals[category]!;

        for (int i = 0; i < goals.length; i++) {
          final goal = goals[i];
          final lastReset =
              DateTime.parse(goal['lastReset'] ?? goal['createdAt']);
          bool shouldReset = false;

          switch (category) {
            case 'today':
            case 'daily':
              shouldReset = !_isSameDay(lastReset, now);
              break;
            case 'weekly':
              shouldReset = now.difference(lastReset).inDays >= 7;
              break;
            case 'monthly':
              shouldReset = now.difference(lastReset).inDays >= 30;
              break;
            case 'yearly':
              shouldReset = now.difference(lastReset).inDays >= 365;
              break;
          }

          if (shouldReset) {
            goals[i]['completed'] = false;
            goals[i]['lastReset'] = now.toIso8601String();
            needsSave = true;
          }
        }

        if (needsSave) {
          await _saveGoals(category, goals);
        }
      }

      if (needsSave) {
        setState(() {});
      }
    } catch (e) {
      // Silent fail
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _saveGoals(
      String category, List<Map<String, dynamic>> goals) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('goals_$category', json.encode(goals));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save goals",
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _addGoal(String category, String text) async {
    final newGoal = {
      'id': 'goal_${DateTime.now().millisecondsSinceEpoch}',
      'text': text,
      'completed': false,
      'createdAt': DateTime.now().toIso8601String(),
      'lastReset': DateTime.now().toIso8601String(),
    };

    setState(() {
      _allGoals[category]!.add(newGoal);
    });

    await _saveGoals(category, _allGoals[category]!);

    Fluttertoast.showToast(
      msg: "Goal added successfully!",
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }

  Future<void> _toggleGoal(String category, int index, bool completed) async {
    setState(() {
      _allGoals[category]![index]['completed'] = completed;
    });

    await _saveGoals(category, _allGoals[category]!);
  }

  Future<void> _removeGoal(String category, int index) async {
    setState(() {
      _allGoals[category]!.removeAt(index);
    });

    await _saveGoals(category, _allGoals[category]!);

    Fluttertoast.showToast(
      msg: "Goal removed",
      backgroundColor: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
      textColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
    );
  }

  void _toggleSection(String category) {
    setState(() {
      _sectionExpanded[category] = !_sectionExpanded[category]!;
    });
  }

  String _getTimeRemaining(String category) {
    final now = DateTime.now();

    switch (category) {
      case 'today':
      case 'daily':
        final tomorrow = DateTime(now.year, now.month, now.day + 1);
        final remaining = tomorrow.difference(now);
        return '${remaining.inHours}h ${remaining.inMinutes % 60}m remaining';
      case 'weekly':
        final nextWeek = now.add(Duration(days: 7 - now.weekday));
        final remaining = nextWeek.difference(now);
        return '${remaining.inDays} days remaining';
      case 'monthly':
        final nextMonth = DateTime(now.year, now.month + 1, 1);
        final remaining = nextMonth.difference(now);
        return '${remaining.inDays} days remaining';
      case 'yearly':
        final nextYear = DateTime(now.year + 1, 1, 1);
        final remaining = nextYear.difference(now);
        return '${remaining.inDays} days remaining';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'track_changes',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('Goals'),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Goal Settings'),
                  content: Text(
                      'Goal management preferences and reset options will be available in a future update.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadGoals();
          await _checkAndResetGoals();
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Today Goals and Must Do Daily Goals at top for visibility
                GoalSectionWidget(
                  title: 'Today Goals',
                  subtitle: _getTimeRemaining('today'),
                  iconName: 'today',
                  goals: _allGoals['today']!,
                  isExpanded: _sectionExpanded['today']!,
                  onToggleExpansion: () => _toggleSection('today'),
                  onToggleGoal: (index, completed) =>
                      _toggleGoal('today', index, completed),
                  onRemoveGoal: (index) => _removeGoal('today', index),
                  onAddGoal: () => showDialog(
                    context: context,
                    builder: (context) => AddGoalDialog(
                      title: 'Add Today Goal',
                      onSubmit: (text) => _addGoal('today', text),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                GoalSectionWidget(
                  title: 'Must Do Daily Goals',
                  subtitle: _getTimeRemaining('daily'),
                  iconName: 'checklist',
                  goals: _allGoals['daily']!,
                  isExpanded: _sectionExpanded['daily']!,
                  onToggleExpansion: () => _toggleSection('daily'),
                  onToggleGoal: (index, completed) =>
                      _toggleGoal('daily', index, completed),
                  onRemoveGoal: (index) => _removeGoal('daily', index),
                  onAddGoal: () => showDialog(
                    context: context,
                    builder: (context) => AddGoalDialog(
                      title: 'Add Daily Goal',
                      onSubmit: (text) => _addGoal('daily', text),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                GoalSectionWidget(
                  title: '7 Day Goals',
                  subtitle: _getTimeRemaining('weekly'),
                  iconName: 'calendar_view_week',
                  goals: _allGoals['weekly']!,
                  isExpanded: _sectionExpanded['weekly']!,
                  onToggleExpansion: () => _toggleSection('weekly'),
                  onToggleGoal: (index, completed) =>
                      _toggleGoal('weekly', index, completed),
                  onRemoveGoal: (index) => _removeGoal('weekly', index),
                  onAddGoal: () => showDialog(
                    context: context,
                    builder: (context) => AddGoalDialog(
                      title: 'Add 7 Day Goal',
                      onSubmit: (text) => _addGoal('weekly', text),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                GoalSectionWidget(
                  title: '30 Day Goals',
                  subtitle: _getTimeRemaining('monthly'),
                  iconName: 'calendar_view_month',
                  goals: _allGoals['monthly']!,
                  isExpanded: _sectionExpanded['monthly']!,
                  onToggleExpansion: () => _toggleSection('monthly'),
                  onToggleGoal: (index, completed) =>
                      _toggleGoal('monthly', index, completed),
                  onRemoveGoal: (index) => _removeGoal('monthly', index),
                  onAddGoal: () => showDialog(
                    context: context,
                    builder: (context) => AddGoalDialog(
                      title: 'Add 30 Day Goal',
                      onSubmit: (text) => _addGoal('monthly', text),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                GoalSectionWidget(
                  title: '1 Year Goals',
                  subtitle: _getTimeRemaining('yearly'),
                  iconName: 'event',
                  goals: _allGoals['yearly']!,
                  isExpanded: _sectionExpanded['yearly']!,
                  onToggleExpansion: () => _toggleSection('yearly'),
                  onToggleGoal: (index, completed) =>
                      _toggleGoal('yearly', index, completed),
                  onRemoveGoal: (index) => _removeGoal('yearly', index),
                  onAddGoal: () => showDialog(
                    context: context,
                    builder: (context) => AddGoalDialog(
                      title: 'Add 1 Year Goal',
                      onSubmit: (text) => _addGoal('yearly', text),
                    ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
