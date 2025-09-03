import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlaybackControlsWidget extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;
  final bool isShuffled;
  final bool isRepeated;

  const PlaybackControlsWidget({
    Key? key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onShuffle,
    required this.onRepeat,
    required this.isShuffled,
    required this.isRepeated,
  }) : super(key: key);

  @override
  State<PlaybackControlsWidget> createState() => _PlaybackControlsWidgetState();
}

class _PlaybackControlsWidgetState extends State<PlaybackControlsWidget>
    with TickerProviderStateMixin {
  late AnimationController _playButtonController;
  late Animation<double> _playButtonAnimation;

  @override
  void initState() {
    super.initState();
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _playButtonAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _playButtonController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _playButtonController.dispose();
    super.dispose();
  }

  void _onPlayPausePressed() {
    HapticFeedback.mediumImpact();
    _playButtonController.forward().then((_) {
      _playButtonController.reverse();
    });
    widget.onPlayPause();
  }

  void _onControlPressed(VoidCallback callback) {
    HapticFeedback.lightImpact();
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Column(
        children: [
          // Main playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous button
              GestureDetector(
                onTap: () => _onControlPressed(widget.onPrevious),
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'skip_previous',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ),
              // Play/Pause button
              GestureDetector(
                onTap: _onPlayPausePressed,
                child: AnimatedBuilder(
                  animation: _playButtonAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _playButtonAnimation.value,
                      child: Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(9.w),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: widget.isPlaying ? 'pause' : 'play_arrow',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 8.w,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Next button
              GestureDetector(
                onTap: () => _onControlPressed(widget.onNext),
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'skip_next',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Secondary controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Shuffle button
              GestureDetector(
                onTap: () => _onControlPressed(widget.onShuffle),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: widget.isShuffled
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'shuffle',
                    color: widget.isShuffled
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
              // Queue button
              GestureDetector(
                onTap: () => _onControlPressed(() {}),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  child: CustomIconWidget(
                    iconName: 'queue_music',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
              // Share button
              GestureDetector(
                onTap: () => _onControlPressed(() {}),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  child: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
              // Repeat button
              GestureDetector(
                onTap: () => _onControlPressed(widget.onRepeat),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: widget.isRepeated
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'repeat',
                    color: widget.isRepeated
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
