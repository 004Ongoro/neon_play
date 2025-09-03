import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SubtitleOverlay extends StatelessWidget {
  final String subtitleText;
  final bool isVisible;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final double backgroundOpacity;

  const SubtitleOverlay({
    super.key,
    required this.subtitleText,
    required this.isVisible,
    this.fontSize = 16.0,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.backgroundOpacity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible || subtitleText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 15.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: backgroundOpacity),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          subtitleText,
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            height: 1.4,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
