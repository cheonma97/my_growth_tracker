import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/entry_actions_menu_widget.dart';
import './widgets/entry_content_widget.dart';

class EntryDetailView extends StatefulWidget {
  const EntryDetailView({Key? key}) : super(key: key);

  @override
  State<EntryDetailView> createState() => _EntryDetailViewState();
}

class _EntryDetailViewState extends State<EntryDetailView> {
  Map<String, dynamic>? currentEntry;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntryData();
  }

  void _loadEntryData() {
    // Get the entry data from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments;

      if (arguments != null && arguments is Map<String, dynamic>) {
        setState(() {
          currentEntry = arguments;
          isLoading = false;
        });
      } else {
        setState(() {
          currentEntry = null;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: isLoading ? _buildLoadingState() : _buildContent(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final entryDate = currentEntry != null
        ? _formatAppBarDate(currentEntry!['createdAt'] as String)
        : 'Loading...';

    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        entryDate,
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      centerTitle: AppTheme.lightTheme.appBarTheme.centerTitle,
      actions: currentEntry != null
          ? [
              EntryActionsMenuWidget(
                entry: currentEntry!,
                onEdit: _handleEditEntry,
                onDelete: _handleDeleteEntry,
              ),
              SizedBox(width: 2.w),
            ]
          : null,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading entry...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (currentEntry == null) {
      return _buildErrorState();
    }

    return EntryContentWidget(
      entry: currentEntry!,
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 48,
            ),
            SizedBox(height: 3.h),
            Text(
              'Entry Not Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'The journal entry you\'re looking for could not be found. It may have been deleted or moved.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Go Back',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditEntry() {
    if (currentEntry != null) {
      Navigator.pushNamed(
        context,
        '/edit-journal-entry',
        arguments: currentEntry,
      ).then((result) {
        // Handle result from edit screen
        if (result != null && result is Map<String, dynamic>) {
          setState(() {
            currentEntry = result;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Entry updated successfully',
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
      });
    }
  }

  void _handleDeleteEntry() {
    if (currentEntry != null) {
      // Simulate deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Entry deleted successfully',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            textColor: AppTheme.lightTheme.colorScheme.primary,
            onPressed: () {
              // Handle undo functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Entry restored',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onInverseSurface,
                    ),
                  ),
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.inverseSurface,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      );

      // Navigate back after deletion
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  String _formatAppBarDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return 'Unknown Date';
    }
  }
}
