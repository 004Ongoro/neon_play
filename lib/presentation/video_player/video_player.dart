import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/subtitle_overlay.dart';
import './widgets/video_controls_overlay.dart';
import './widgets/video_settings_modal.dart';
import './widgets/volume_brightness_overlay.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer>
    with TickerProviderStateMixin {
  // Video player state
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _controlsVisible = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(minutes: 2, seconds: 30);

  // Settings state
  double _playbackSpeed = 1.0;
  String _selectedSubtitleTrack = 'English';
  String _selectedAudioTrack = 'English (Stereo)';
  String _selectedQuality = '1080p';

  // UI state
  bool _volumeBrightnessVisible = false;
  bool _isVolumeControl = true;
  double _volumeLevel = 0.7;
  double _brightnessLevel = 0.8;
  String _currentSubtitle = '';
  bool _subtitlesEnabled = true;

  // Timers and controllers
  Timer? _hideControlsTimer;
  Timer? _positionTimer;
  Timer? _hideVolumeTimer;

  // Mock data
  final Map<String, dynamic> _currentVideo = {
    "id": 1,
    "title": "The Art of Cinematic Storytelling",
    "description":
        "Explore the fundamentals of visual narrative and how master filmmakers craft compelling stories through the lens.",
    "duration": "2:30",
    "thumbnail":
        "https://images.unsplash.com/photo-1489599511986-c2d6b3c5c2e6?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "videoUrl":
        "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
    "quality": ["480p", "720p", "1080p", "4K"],
    "subtitles": ["Off", "English", "Spanish", "French", "German"],
    "audioTracks": ["English (Stereo)", "English (5.1)", "Spanish", "French"],
    "chapters": [
      {"title": "Introduction", "time": "0:00"},
      {"title": "Visual Composition", "time": "0:45"},
      {"title": "Camera Movement", "time": "1:30"},
      {"title": "Color Theory", "time": "2:00"},
    ]
  };

  final List<Map<String, dynamic>> _playlist = [
    {
      "id": 1,
      "title": "The Art of Cinematic Storytelling",
      "duration": "2:30",
      "thumbnail":
          "https://images.unsplash.com/photo-1489599511986-c2d6b3c5c2e6?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "title": "Advanced Color Grading Techniques",
      "duration": "3:15",
      "thumbnail":
          "https://images.unsplash.com/photo-1518611012118-696072aa579a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "title": "Sound Design Masterclass",
      "duration": "4:20",
      "thumbnail":
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _startPositionTimer();
    _setLandscapeOrientation();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _positionTimer?.cancel();
    _hideVolumeTimer?.cancel();
    _resetOrientation();
    super.dispose();
  }

  void _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _initializePlayer() {
    // Simulate video loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlaying = true;
        });
        _startAutoHideTimer();
      }
    });
  }

  void _startPositionTimer() {
    _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isPlaying && mounted) {
        setState(() {
          _currentPosition = Duration(
            milliseconds: (_currentPosition.inMilliseconds + 500)
                .clamp(0, _totalDuration.inMilliseconds),
          );

          // Update subtitle based on position
          _updateSubtitle();
        });

        if (_currentPosition >= _totalDuration) {
          _onVideoCompleted();
        }
      }
    });
  }

  void _updateSubtitle() {
    if (!_subtitlesEnabled || _selectedSubtitleTrack == 'Off') {
      _currentSubtitle = '';
      return;
    }

    // Mock subtitle data based on time
    final seconds = _currentPosition.inSeconds;
    if (seconds >= 0 && seconds < 15) {
      _currentSubtitle = 'Welcome to the art of cinematic storytelling.';
    } else if (seconds >= 15 && seconds < 30) {
      _currentSubtitle =
          'Every frame tells a story through visual composition.';
    } else if (seconds >= 30 && seconds < 45) {
      _currentSubtitle =
          'Camera movement guides the viewer\'s emotional journey.';
    } else if (seconds >= 45 && seconds < 60) {
      _currentSubtitle = 'Color theory enhances the narrative impact.';
    } else {
      _currentSubtitle = '';
    }
  }

  void _onVideoCompleted() {
    setState(() {
      _isPlaying = false;
      _currentPosition = Duration.zero;
    });
    _showControls();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    _showControls();
    HapticFeedback.lightImpact();
  }

  void _seekTo(Duration position) {
    setState(() {
      _currentPosition = Duration(
        milliseconds: position.inMilliseconds.clamp(0, _totalDuration.inMilliseconds)
      );
    });
    _showControls();
  }

  void _showControls() {
    setState(() {
      _controlsVisible = true;
    });
    _startAutoHideTimer();
  }

  void _hideControls() {
    setState(() {
      _controlsVisible = false;
    });
  }

  void _toggleControlsVisibility() {
    if (_controlsVisible) {
      _hideControls();
    } else {
      _showControls();
    }
  }

  void _startAutoHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        _hideControls();
      }
    });
  }

  void _showVolumeControl(double delta) {
    setState(() {
      _volumeLevel = (_volumeLevel + delta).clamp(0.0, 1.0);
      _volumeBrightnessVisible = true;
      _isVolumeControl = true;
    });

    _hideVolumeTimer?.cancel();
    _hideVolumeTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _volumeBrightnessVisible = false;
        });
      }
    });

    HapticFeedback.selectionClick();
  }

  void _showBrightnessControl(double delta) {
    setState(() {
      _brightnessLevel = (_brightnessLevel + delta).clamp(0.0, 1.0);
      _volumeBrightnessVisible = true;
      _isVolumeControl = false;
    });

    _hideVolumeTimer?.cancel();
    _hideVolumeTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _volumeBrightnessVisible = false;
        });
      }
    });

    HapticFeedback.selectionClick();
  }

  void _onPreviousTrack() {
    // Navigate to previous video in playlist
    HapticFeedback.mediumImpact();
    setState(() {
      _currentPosition = Duration.zero;
      _isPlaying = true;
    });
    _showControls();
  }

  void _onNextTrack() {
    // Navigate to next video in playlist
    HapticFeedback.mediumImpact();
    setState(() {
      _currentPosition = Duration.zero;
      _isPlaying = true;
    });
    _showControls();
  }

  void _showSettingsModal() {
    _hideControls();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: 80.h,
        child: VideoSettingsModal(
          playbackSpeed: _playbackSpeed,
          onPlaybackSpeedChanged: (speed) {
            setState(() {
              _playbackSpeed = speed;
            });
          },
          subtitleTracks: (_currentVideo["subtitles"] as List).cast<String>(),
          selectedSubtitleTrack: _selectedSubtitleTrack,
          onSubtitleTrackChanged: (track) {
            setState(() {
              _selectedSubtitleTrack = track;
              _subtitlesEnabled = track != 'Off';
            });
          },
          audioTracks: (_currentVideo["audioTracks"] as List).cast<String>(),
          selectedAudioTrack: _selectedAudioTrack,
          onAudioTrackChanged: (track) {
            setState(() {
              _selectedAudioTrack = track;
            });
          },
          qualityOptions: (_currentVideo["quality"] as List).cast<String>(),
          selectedQuality: _selectedQuality,
          onQualityChanged: (quality) {
            setState(() {
              _selectedQuality = quality;
            });
          },
        ),
      ),
    ).then((_) {
      _showControls();
    });
  }

  void _onBackPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControlsVisibility,
        onDoubleTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          final tapPosition = details.globalPosition.dx;

          if (tapPosition < screenWidth * 0.4) {
            // Left side - rewind 10 seconds
            final newPosition = Duration(
              milliseconds: (_currentPosition.inMilliseconds - 10000)
                  .clamp(0, _totalDuration.inMilliseconds),
            );
            _seekTo(newPosition);
            HapticFeedback.mediumImpact();
          } else if (tapPosition > screenWidth * 0.6) {
            // Right side - forward 10 seconds
            final newPosition = Duration(
              milliseconds: (_currentPosition.inMilliseconds + 10000)
                  .clamp(0, _totalDuration.inMilliseconds),
            );
            _seekTo(newPosition);
            HapticFeedback.mediumImpact();
          }
        },
        onVerticalDragUpdate: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          final dragPosition = details.globalPosition.dx;
          final delta = -details.delta.dy / 200; // Sensitivity adjustment

          if (dragPosition < screenWidth * 0.5) {
            // Left side - brightness control
            _showBrightnessControl(delta);
          } else {
            // Right side - volume control
            _showVolumeControl(delta);
          }
        },
        child: Stack(
          children: [
            // Video player background
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.accent,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Loading video...',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              // Video thumbnail/preview
                              CustomImageWidget(
                                imageUrl: _currentVideo["thumbnail"] as String,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),

                              // Play overlay when paused
                              if (!_isPlaying && !_isLoading)
                                Container(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'play_arrow',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        size: 15.w,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),

            // Subtitle overlay
            if (!_isLoading)
              SubtitleOverlay(
                subtitleText: _currentSubtitle,
                isVisible: _subtitlesEnabled && _currentSubtitle.isNotEmpty,
                fontSize: 4.w,
                textColor: Colors.white,
                backgroundColor: Colors.black,
                backgroundOpacity: 0.7,
              ),

            // Video controls overlay
            if (!_isLoading)
              VideoControlsOverlay(
                isVisible: _controlsVisible,
                isPlaying: _isPlaying,
                currentPosition: _currentPosition,
                totalDuration: _totalDuration,
                onPlayPause: _togglePlayPause,
                onPrevious: _onPreviousTrack,
                onNext: _onNextTrack,
                onSeek: _seekTo,
                onSettings: _showSettingsModal,
                onBack: _onBackPressed,
                mediaTitle: _currentVideo["title"] as String,
                onToggleVisibility: _toggleControlsVisibility,
              ),

            // Volume/Brightness overlay
            VolumeBrightnessOverlay(
              isVisible: _volumeBrightnessVisible,
              isVolume: _isVolumeControl,
              value: _isVolumeControl ? _volumeLevel : _brightnessLevel,
              onHide: () {
                setState(() {
                  _volumeBrightnessVisible = false;
                });
              },
            ),

            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.accent,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Initializing player...',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}