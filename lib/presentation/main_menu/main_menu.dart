import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_menu_button.dart';
import './widgets/app_logo_widget.dart';
import './widgets/exit_confirmation_dialog.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    _backgroundAnimationController.forward();
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await ExitConfirmationDialog.show(context);
    return shouldExit ?? false;
  }

  void _navigateToNewEntry() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/new-journal-entry');
  }

  void _navigateToViewEntries() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/journal-entries-list');
  }

  void _navigateToWebsite() {
    HapticFeedback.lightImpact();
    _showWebsitePlaceholder();
  }

  void _navigateToGoals() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/goals-dashboard');
  }

  void _showWebsitePlaceholder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        surfaceTintColor: AppTheme.lightTheme.colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'web',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Website Feature',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primaryContainer,
                    AppTheme.lightTheme.colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'construction',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 12.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Coming Soon!',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Website integration and cloud sync features are currently under development. Stay tuned for updates!',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Got it',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.lightTheme.colorScheme.surface,
                    AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      SizedBox(height: 4.h),
                      // App Logo and Title
                      const AppLogoWidget(),
                      SizedBox(height: 6.h),
                      // Welcome Message
                      FadeTransition(
                        opacity: _backgroundAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.shadow
                                    .withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Welcome to your personal growth journey',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Choose an option below to get started with your journaling experience',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Menu Buttons
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedMenuButton(
                              title: 'New Entry',
                              iconName: 'add',
                              onPressed: _navigateToNewEntry,
                              animationDelay: 200,
                              isPrimary: true,
                            ),
                            AnimatedMenuButton(
                              title: 'View Entries',
                              iconName: 'list',
                              onPressed: _navigateToViewEntries,
                              animationDelay: 350,
                            ),
                            AnimatedMenuButton(
                              title: 'Goals',
                              iconName: 'track_changes',
                              onPressed: _navigateToGoals,
                              animationDelay: 425,
                            ),
                            AnimatedMenuButton(
                              title: 'Website',
                              iconName: 'web',
                              onPressed: _navigateToWebsite,
                              animationDelay: 500,
                            ),
                          ],
                        ),
                      ),
                      // Footer
                      FadeTransition(
                        opacity: _backgroundAnimation,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'security',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Your data stays private on your device',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
