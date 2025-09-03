import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> mediaItem;
  final VoidCallback onPlay;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onDismiss;

  const ContextMenuWidget({
    Key? key,
    required this.mediaItem,
    required this.onPlay,
    required this.onAddToPlaylist,
    required this.onShare,
    required this.onDelete,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = mediaItem['title'] as String? ?? 'Unknown Title';
    final String type = mediaItem['type'] as String? ?? 'video';

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent dismissal when tapping menu
            child: Container(
              width: 80.w,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: type == 'video' ? 'videocam' : 'music_note',
                          color: AppTheme.accent,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onDismiss,
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu items
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: 'play_arrow',
                          title: 'Play Now',
                          onTap: () {
                            onDismiss();
                            onPlay();
                          },
                        ),
                        _buildMenuItem(
                          icon: 'playlist_add',
                          title: 'Add to Playlist',
                          onTap: () {
                            onDismiss();
                            onAddToPlaylist();
                          },
                        ),
                        _buildMenuItem(
                          icon: 'share',
                          title: 'Share',
                          onTap: () {
                            onDismiss();
                            onShare();
                          },
                        ),
                        _buildMenuItem(
                          icon: 'delete',
                          title: 'Delete',
                          onTap: () {
                            onDismiss();
                            onDelete();
                          },
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
              size: 22,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: isDestructive
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
