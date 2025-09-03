import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomToolbarWidget extends StatelessWidget {
  final VoidCallback onShufflePlay;
  final VoidCallback onAddTracks;
  final VoidCallback onSharePlaylist;
  final bool isShuffleEnabled;

  const BottomToolbarWidget({
    Key? key,
    required this.onShufflePlay,
    required this.onAddTracks,
    required this.onSharePlaylist,
    this.isShuffleEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Shuffle Play Button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: onShufflePlay,
                icon: CustomIconWidget(
                  iconName: isShuffleEnabled ? 'shuffle_on' : 'shuffle',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                label: Text(
                  'Shuffle Play',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 3.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            // Add Tracks Button
            Expanded(
              child: OutlinedButton(
                onPressed: onAddTracks,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.accent,
                      size: 5.w,
                    ),
                    SizedBox(width: 1.w),
                    Flexible(
                      child: Text(
                        'Add',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.accent, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 3.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            // Share Button
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: onSharePlaylist,
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
                  size: 5.w,
                ),
                padding: EdgeInsets.all(3.w),
                constraints: BoxConstraints(
                  minWidth: 12.w,
                  minHeight: 12.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
