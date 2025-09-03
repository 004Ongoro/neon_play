import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  double _initializationProgress = 0.0;
  String _currentTask = 'Initializing media player...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _hideSystemUI();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading indicator animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _startInitialization() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Check media codec support
    await _updateProgress(0.2, 'Checking media codec support...');
    await Future.delayed(const Duration(milliseconds: 400));

    // Load user preferences
    await _updateProgress(0.4, 'Loading user preferences...');
    await Future.delayed(const Duration(milliseconds: 300));

    // Scan for recently played media
    await _updateProgress(0.6, 'Scanning recent media...');
    await Future.delayed(const Duration(milliseconds: 400));

    // Prepare cached playlists
    await _updateProgress(0.8, 'Preparing playlists...');
    await Future.delayed(const Duration(milliseconds: 300));

    // Complete initialization
    await _updateProgress(1.0, 'Ready to play!');
    await Future.delayed(const Duration(milliseconds: 500));

    _navigateToNextScreen();
  }

  Future<void> _updateProgress(double progress, String task) async {
    if (mounted) {
      setState(() {
        _initializationProgress = progress;
        _currentTask = task;
      });
    }
  }

  void _navigateToNextScreen() {
    _restoreSystemUI();

    // Simulate navigation logic based on user state
    final bool hasRecentMedia = _checkForRecentMedia();
    final bool isFirstTime = _checkIfFirstTime();

    String nextRoute;
    if (isFirstTime) {
      nextRoute = '/media-library-home'; // First-time users see media import
    } else if (hasRecentMedia) {
      nextRoute = '/video-player'; // Users with recent media go to player
    } else {
      nextRoute = '/media-library-home'; // Returning users see library home
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  bool _checkForRecentMedia() {
    // Simulate checking for recent media
    // In real implementation, this would check SharedPreferences or local storage
    return DateTime.now().millisecondsSinceEpoch % 2 == 0;
  }

  bool _checkIfFirstTime() {
    // Simulate first-time user check
    // In real implementation, this would check SharedPreferences
    return DateTime.now().millisecondsSinceEpoch % 3 == 0;
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    _restoreSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.surface,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLoadingIndicator(),
                      SizedBox(height: 3.h),
                      _buildProgressBar(),
                      SizedBox(height: 2.h),
                      _buildTaskText(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accent,
                AppTheme.accent.withValues(alpha: 0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'play_arrow',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 12.w,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Neon Play',
          style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Advanced Media Player',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Container(
          width: 8.w,
          height: 8.w,
          child: CircularProgressIndicator(
            value: _isInitializing ? null : 1.0,
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
            backgroundColor:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.3),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 0.8.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: LinearProgressIndicator(
          value: _initializationProgress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
        ),
      ),
    );
  }

  Widget _buildTaskText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _currentTask,
        key: ValueKey(_currentTask),
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.8),
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
