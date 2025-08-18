import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/date_filter_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/journal_entry_card.dart';
import './widgets/search_bar_widget.dart';

class JournalEntriesList extends StatefulWidget {
  const JournalEntriesList({Key? key}) : super(key: key);

  @override
  State<JournalEntriesList> createState() => _JournalEntriesListState();
}

class _JournalEntriesListState extends State<JournalEntriesList>
    with TickerProviderStateMixin {
  late AnimationController _listAnimationController;
  late AnimationController _fabAnimationController;

  bool _isSearchActive = false;
  String _searchQuery = '';
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  bool _isLoading = true;

  List<Map<String, dynamic>> _allEntries = [];
  List<Map<String, dynamic>> _filteredEntries = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSavedEntries();
  }

  void _initializeAnimations() {
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _listAnimationController.forward();
    _fabAnimationController.forward();
  }

  Future<void> _loadSavedEntries() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final savedEntries = prefs.getStringList('journal_entries') ?? [];

      List<Map<String, dynamic>> loadedEntries = [];

      for (String entryJson in savedEntries) {
        try {
          final Map<String, dynamic> entry = json.decode(entryJson);
          loadedEntries.add(entry);
        } catch (e) {
          // Skip invalid entries
          continue;
        }
      }

      // Sort entries by creation date (newest first)
      loadedEntries.sort((a, b) {
        final dateA = DateTime.parse(a['createdAt'] as String);
        final dateB = DateTime.parse(b['createdAt'] as String);
        return dateB.compareTo(dateA);
      });

      setState(() {
        _allEntries = loadedEntries;
        _filteredEntries = List.from(_allEntries);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _allEntries = [];
        _filteredEntries = [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App bar or search bar
            _isSearchActive
                ? SearchBarWidget(
                    onSearchChanged: _handleSearchChanged,
                    onClose: _handleSearchClose,
                  )
                : _buildAppBar(),

            // Main content
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),

          SizedBox(width: 2.w),

          // Title
          Expanded(
            child: Text(
              'My Entries',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Search button
          IconButton(
            onPressed: _handleSearchOpen,
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),

          // Filter button
          IconButton(
            onPressed: _showDateFilter,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: (_filterStartDate != null || _filterEndDate != null)
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }

    if (_filteredEntries.isEmpty && _allEntries.isNotEmpty) {
      return _buildNoResultsFound();
    }

    if (_allEntries.isEmpty) {
      return EmptyStateWidget(
        onCreateEntry: _navigateToNewEntry,
      );
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: AnimatedBuilder(
        animation: _listAnimationController,
        builder: (context, child) {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = _filteredEntries[index];
              final animation = Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: _listAnimationController,
                curve: Interval(
                  (index * 0.1).clamp(0.0, 1.0),
                  ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                  curve: Curves.easeOutCubic,
                ),
              ));

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: JournalEntryCard(
                    entry: entry,
                    onTap: () => _navigateToEntryDetail(entry),
                    onDelete: () => _deleteEntry(entry),
                    onEdit: () => _navigateToEditEntry(entry),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No entries found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms or clear the search to see all entries.'
                  : 'No entries match the selected date range. Try adjusting your filters.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            OutlinedButton(
              onPressed: _clearAllFilters,
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabAnimationController,
      child: FloatingActionButton(
        onPressed: _navigateToNewEntry,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  // Event handlers
  void _handleSearchOpen() {
    setState(() {
      _isSearchActive = true;
    });
  }

  void _handleSearchClose() {
    setState(() {
      _isSearchActive = false;
      _searchQuery = '';
    });
    _applyFilters();
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _showDateFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => DateFilterWidget(
        onDateRangeSelected: (startDate, endDate) {
          setState(() {
            _filterStartDate = startDate;
            _filterEndDate = endDate;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allEntries);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((entry) {
        final title = (entry['title'] as String? ?? '').toLowerCase();
        final body = (entry['body'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || body.contains(query);
      }).toList();
    }

    // Apply date filter
    if (_filterStartDate != null || _filterEndDate != null) {
      filtered = filtered.where((entry) {
        final entryDate = DateTime.parse(entry['date'] as String);

        if (_filterStartDate != null && entryDate.isBefore(_filterStartDate!)) {
          return false;
        }

        if (_filterEndDate != null &&
            entryDate.isAfter(_filterEndDate!.add(Duration(days: 1)))) {
          return false;
        }

        return true;
      }).toList();
    }

    setState(() {
      _filteredEntries = filtered;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _filterStartDate = null;
      _filterEndDate = null;
      _isSearchActive = false;
    });
    _applyFilters();
  }

  Future<void> _handleRefresh() async {
    await _loadSavedEntries();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entries refreshed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteEntry(Map<String, dynamic> entry) async {
    final String entryId = entry['id'] as String;
    final int originalIndex = _allEntries.indexWhere((e) => e['id'] == entryId);

    if (originalIndex != -1) {
      final deletedEntry = _allEntries.removeAt(originalIndex);
      _applyFilters();

      // Update SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        final updatedEntries = _allEntries.map((e) => json.encode(e)).toList();
        await prefs.setStringList('journal_entries', updatedEntries);
      } catch (e) {
        // Handle error silently
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Entry deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setState(() {
                _allEntries.insert(originalIndex, deletedEntry);
              });
              _applyFilters();

              // Restore to SharedPreferences
              try {
                final prefs = await SharedPreferences.getInstance();
                final updatedEntries =
                    _allEntries.map((e) => json.encode(e)).toList();
                await prefs.setStringList('journal_entries', updatedEntries);
              } catch (e) {
                // Handle error silently
              }
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // Navigation methods
  void _navigateToNewEntry() {
    Navigator.pushNamed(context, '/new-journal-entry').then((_) {
      // Refresh the list when returning from new entry
      _loadSavedEntries();
    });
  }

  void _navigateToEntryDetail(Map<String, dynamic> entry) {
    Navigator.pushNamed(
      context,
      '/entry-detail-view',
      arguments: entry,
    ).then((_) {
      // Refresh the list when returning from detail view
      _loadSavedEntries();
    });
  }

  void _navigateToEditEntry(Map<String, dynamic> entry) {
    Navigator.pushNamed(
      context,
      '/edit-journal-entry',
      arguments: entry,
    ).then((_) {
      // Refresh the list when returning from edit
      _loadSavedEntries();
    });
  }
}
