import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoControlsOverlay extends StatefulWidget {
  final bool isVisible;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(Duration) onSeek;
  final VoidCallback onSettings;
  final VoidCallback onBack;
  final String mediaTitle;
  final VoidCallback onToggleVisibility;

  const VideoControlsOverlay({
    super.key,
    required this.isVisible,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onSeek,
    required this.onSettings,
    required this.onBack,
    required this.mediaTitle,
    required this.onToggleVisibility,
  });

  @override
  State<VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<VideoControlsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VideoControlsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggleVisibility,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Stack(
                children: [
                  // Top overlay with gradient
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 20.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: widget.onBack,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'arrow_back',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  widget.mediaTitle,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: widget.onSettings,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'settings',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Center play/pause button
                  Center(
                    child: GestureDetector(
                      onTap: widget.onPlayPause,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: widget.isPlaying ? 'pause' : 'play_arrow',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 12.w,
                        ),
                      ),
                    ),
                  ),

                  // Bottom overlay with controls
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 25.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Timeline scrubber
                              Row(
                                children: [
                                  Text(
                                    _formatDuration(widget.currentPosition),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: AppTheme.accent,
                                        inactiveTrackColor: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.3),
                                        thumbColor: AppTheme.accent,
                                        overlayColor: AppTheme.accent
                                            .withValues(alpha: 0.2),
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 8.0),
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                                overlayRadius: 16.0),
                                        trackHeight: 3.0,
                                      ),
                                      child: Slider(
                                        value: widget.totalDuration
                                                    .inMilliseconds >
                                                0
                                            ? widget
                                                .currentPosition.inMilliseconds
                                                .toDouble()
                                            : 0.0,
                                        min: 0.0,
                                        max: widget.totalDuration.inMilliseconds
                                            .toDouble(),
                                        onChanged: (value) {
                                          setState(() {
                                            _isDragging = true;
                                          });
                                          widget.onSeek(Duration(
                                              milliseconds: value.toInt()));
                                        },
                                        onChangeEnd: (value) {
                                          setState(() {
                                            _isDragging = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    _formatDuration(widget.totalDuration),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.h),
                              // Control buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: widget.onPrevious,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'skip_previous',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        size: 8.w,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final newPosition = Duration(
                                        milliseconds: (widget.currentPosition
                                                    .inMilliseconds -
                                                10000)
                                            .clamp(
                                                0,
                                                widget.totalDuration
                                                    .inMilliseconds),
                                      );
                                      widget.onSeek(newPosition);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'replay_10',
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface,
                                            size: 6.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: widget.onPlayPause,
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CustomIconWidget(
                                        iconName: widget.isPlaying
                                            ? 'pause'
                                            : 'play_arrow',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        size: 10.w,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final newPosition = Duration(
                                        milliseconds: (widget.currentPosition
                                                    .inMilliseconds +
                                                10000)
                                            .clamp(
                                                0,
                                                widget.totalDuration
                                                    .inMilliseconds),
                                      );
                                      widget.onSeek(newPosition);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'forward_10',
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface,
                                            size: 6.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: widget.onNext,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'skip_next',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        size: 8.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
