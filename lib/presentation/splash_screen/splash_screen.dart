import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textOpacityAnimation;

  String _displayedText = '';
  final String _fullText = 'Welcome to Your Growth Journey';
  int _currentIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    // Text opacity animation
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    ));
  }

  Future<void> _startSplashSequence() async {
    // Hide system UI for full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Start logo animation
    _logoController.forward();

    // Wait for logo animation to reach 60% completion
    await Future.delayed(const Duration(milliseconds: 900));

    // Start text animation and typing effect
    _textController.forward();
    _startTypingEffect();

    // Initialize app services in background
    _initializeAppServices();

    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 3000));

    // Navigate to main menu
    if (mounted && _isInitialized) {
      _navigateToMainMenu();
    }
  }

  void _startTypingEffect() {
    const typingSpeed = Duration(milliseconds: 80);

    void typeNextCharacter() {
      if (_currentIndex < _fullText.length && mounted) {
        setState(() {
          _displayedText = _fullText.substring(0, _currentIndex + 1);
          _currentIndex++;
        });

        Future.delayed(typingSpeed, typeNextCharacter);
      }
    }

    typeNextCharacter();
  }

  Future<void> _initializeAppServices() async {
    try {
      // Simulate database initialization
      await Future.delayed(const Duration(milliseconds: 1500));

      // Simulate loading user preferences
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate theme setup
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  void _navigateToMainMenu() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Navigate with fade transition
    Navigator.pushReplacementNamed(context, '/main-menu');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.surface,
              AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              AppTheme.lightTheme.colorScheme.surface,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Logo section with animations
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoFadeAnimation.value,
                      child: Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.w),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'auto_graph',
                            color: Colors.white,
                            size: 12.w,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // App title
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Text(
                      'My Growth Tracker',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),

              SizedBox(height: 6.h),

              // Welcome text with typing effect
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: Container(
                      width: 80.w,
                      height: 8.h,
                      alignment: Alignment.center,
                      child: Text(
                        _displayedText,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),

              // Spacer to maintain center alignment
              const Spacer(flex: 2),

              // Loading indicator
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textOpacityAnimation.value * 0.7,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: SizedBox(
                        width: 6.w,
                        height: 6.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
