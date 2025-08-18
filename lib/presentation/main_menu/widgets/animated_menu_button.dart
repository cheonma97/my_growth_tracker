import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnimatedMenuButton extends StatefulWidget {
  final String title;
  final String iconName;
  final VoidCallback onPressed;
  final int animationDelay;
  final bool isPrimary;

  const AnimatedMenuButton({
    Key? key,
    required this.title,
    required this.iconName,
    required this.onPressed,
    required this.animationDelay,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  State<AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.8,
        curve: Curves.easeOut,
      ),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.2,
        1.0,
        curve: Curves.easeOutCubic,
      ),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.4,
        1.0,
        curve: Curves.elasticOut,
      ),
    ));

    // Start animation with delay
    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 80.w,
                height: 7.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                child: widget.isPrimary
                    ? ElevatedButton.icon(
                        onPressed: widget.onPressed,
                        icon: CustomIconWidget(
                          iconName: widget.iconName,
                          color: Colors.white,
                          size: 6.w,
                        ),
                        label: Text(
                          widget.title,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: AppTheme.lightTheme.colorScheme.shadow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: widget.onPressed,
                        icon: CustomIconWidget(
                          iconName: widget.iconName,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        ),
                        label: Text(
                          widget.title,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          side: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
