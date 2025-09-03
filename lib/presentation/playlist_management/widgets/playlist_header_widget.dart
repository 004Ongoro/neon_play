import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlaylistHeaderWidget extends StatefulWidget {
  final String playlistTitle;
  final String artworkUrl;
  final int trackCount;
  final String totalDuration;
  final Function(String) onTitleChanged;

  const PlaylistHeaderWidget({
    Key? key,
    required this.playlistTitle,
    required this.artworkUrl,
    required this.trackCount,
    required this.totalDuration,
    required this.onTitleChanged,
  }) : super(key: key);

  @override
  State<PlaylistHeaderWidget> createState() => _PlaylistHeaderWidgetState();
}

class _PlaylistHeaderWidgetState extends State<PlaylistHeaderWidget> {
  bool _isEditing = false;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.playlistTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _finishEditing() {
    setState(() {
      _isEditing = false;
    });
    widget.onTitleChanged(_titleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.surface,
            AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Artwork thumbnail
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: AppTheme.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: CustomImageWidget(
                imageUrl: widget.artworkUrl,
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Playlist title (editable)
          GestureDetector(
            onTap: _isEditing ? null : _startEditing,
            child: _isEditing
                ? Container(
                    width: 80.w,
                    child: TextField(
                      controller: _titleController,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                      ),
                      onSubmitted: (_) => _finishEditing(),
                      onTapOutside: (_) => _finishEditing(),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          widget.playlistTitle,
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 4.w,
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 1.h),
          // Track count and duration
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.trackCount} tracks',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: 1,
                height: 3.w,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.3),
              ),
              Text(
                widget.totalDuration,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
