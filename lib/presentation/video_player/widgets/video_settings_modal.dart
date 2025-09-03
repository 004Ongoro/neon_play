import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoSettingsModal extends StatefulWidget {
  final double playbackSpeed;
  final Function(double) onPlaybackSpeedChanged;
  final List<String> subtitleTracks;
  final String selectedSubtitleTrack;
  final Function(String) onSubtitleTrackChanged;
  final List<String> audioTracks;
  final String selectedAudioTrack;
  final Function(String) onAudioTrackChanged;
  final List<String> qualityOptions;
  final String selectedQuality;
  final Function(String) onQualityChanged;

  const VideoSettingsModal({
    super.key,
    required this.playbackSpeed,
    required this.onPlaybackSpeedChanged,
    required this.subtitleTracks,
    required this.selectedSubtitleTrack,
    required this.onSubtitleTrackChanged,
    required this.audioTracks,
    required this.selectedAudioTrack,
    required this.onAudioTrackChanged,
    required this.qualityOptions,
    required this.selectedQuality,
    required this.onQualityChanged,
  });

  @override
  State<VideoSettingsModal> createState() => _VideoSettingsModalState();
}

class _VideoSettingsModalState extends State<VideoSettingsModal> {
  final List<double> _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Video Settings',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 5.w,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Playback Speed Section
                  _buildSectionHeader('Playback Speed'),
                  SizedBox(height: 2.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: _speedOptions.map((speed) {
                        final isSelected = widget.playbackSpeed == speed;
                        return ListTile(
                          title: Text(
                            '${speed}x',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.accent
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          trailing: isSelected
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.accent,
                                  size: 5.w,
                                )
                              : null,
                          onTap: () {
                            widget.onPlaybackSpeedChanged(speed);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Subtitles Section
                  _buildSectionHeader('Subtitles'),
                  SizedBox(height: 2.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: widget.subtitleTracks.map((track) {
                        final isSelected =
                            widget.selectedSubtitleTrack == track;
                        return ListTile(
                          title: Text(
                            track,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.accent
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          trailing: isSelected
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.accent,
                                  size: 5.w,
                                )
                              : null,
                          onTap: () {
                            widget.onSubtitleTrackChanged(track);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Audio Tracks Section
                  _buildSectionHeader('Audio Track'),
                  SizedBox(height: 2.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: widget.audioTracks.map((track) {
                        final isSelected = widget.selectedAudioTrack == track;
                        return ListTile(
                          title: Text(
                            track,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.accent
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          trailing: isSelected
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.accent,
                                  size: 5.w,
                                )
                              : null,
                          onTap: () {
                            widget.onAudioTrackChanged(track);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Quality Section
                  _buildSectionHeader('Video Quality'),
                  SizedBox(height: 2.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: widget.qualityOptions.map((quality) {
                        final isSelected = widget.selectedQuality == quality;
                        return ListTile(
                          title: Text(
                            quality,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.accent
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          trailing: isSelected
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.accent,
                                  size: 5.w,
                                )
                              : null,
                          onTap: () {
                            widget.onQualityChanged(quality);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
