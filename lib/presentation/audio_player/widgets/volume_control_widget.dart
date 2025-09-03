import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VolumeControlWidget extends StatefulWidget {
  final double volume;
  final Function(double) onVolumeChanged;

  const VolumeControlWidget({
    Key? key,
    required this.volume,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  State<VolumeControlWidget> createState() => _VolumeControlWidgetState();
}

class _VolumeControlWidgetState extends State<VolumeControlWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isVisible = false;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
    if (_isVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      child: Column(
        children: [
          // Volume toggle button
          GestureDetector(
            onTap: _toggleVisibility,
            child: Container(
              width: double.infinity,
              height: 6.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: widget.volume == 0
                        ? 'volume_off'
                        : widget.volume < 0.5
                            ? 'volume_down'
                            : 'volume_up',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${(widget.volume * 100).round()}%',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: _isVisible ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ],
              ),
            ),
          ),
          // Volume slider (animated)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - _fadeAnimation.value) * 20),
                  child: Container(
                    height: _fadeAnimation.value * 8.h,
                    child: _fadeAnimation.value > 0
                        ? Column(
                            children: [
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'volume_down',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.7),
                                    size: 4.w,
                                  ),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        inactiveTrackColor: AppTheme
                                            .lightTheme.colorScheme.surface
                                            .withValues(alpha: 0.3),
                                        thumbColor: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        overlayColor: AppTheme
                                            .lightTheme.colorScheme.primary
                                            .withValues(alpha: 0.2),
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 6.0),
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                                overlayRadius: 12.0),
                                        trackHeight: 3.0,
                                      ),
                                      child: Slider(
                                        value: widget.volume,
                                        onChanged: widget.onVolumeChanged,
                                        min: 0.0,
                                        max: 1.0,
                                        divisions: 20,
                                      ),
                                    ),
                                  ),
                                  CustomIconWidget(
                                    iconName: 'volume_up',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.7),
                                    size: 4.w,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
