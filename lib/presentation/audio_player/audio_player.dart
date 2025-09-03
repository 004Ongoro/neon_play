import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/album_artwork_widget.dart';
import './widgets/mini_player_widget.dart';
import './widgets/playback_controls_widget.dart';
import './widgets/progress_slider_widget.dart';
import './widgets/track_info_widget.dart';
import './widgets/volume_control_widget.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({Key? key}) : super(key: key);

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer>
    with TickerProviderStateMixin {
  // Audio player state
  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isRepeated = false;
  bool _showMiniPlayer = false;
  double _volume = 0.7;
  Duration _currentPosition = const Duration(minutes: 2, seconds: 15);
  Duration _totalDuration = const Duration(minutes: 4, seconds: 32);
  int _currentTrackIndex = 0;

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Mock audio tracks data
  final List<Map<String, dynamic>> _audioTracks = [
    {
      "id": 1,
      "title": "Midnight Dreams",
      "artist": "Luna Eclipse",
      "album": "Nocturnal Vibes",
      "duration": "4:32",
      "imageUrl":
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=500&h=500&fit=crop",
      "audioUrl": "https://example.com/audio/midnight-dreams.mp3",
    },
    {
      "id": 2,
      "title": "Electric Pulse",
      "artist": "Neon Synthwave",
      "album": "Digital Horizons",
      "duration": "3:45",
      "imageUrl":
          "https://images.unsplash.com/photo-1571330735066-03aaa9429d89?w=500&h=500&fit=crop",
      "audioUrl": "https://example.com/audio/electric-pulse.mp3",
    },
    {
      "id": 3,
      "title": "Ocean Waves",
      "artist": "Ambient Collective",
      "album": "Nature Sounds",
      "duration": "6:18",
      "imageUrl":
          "https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=500&h=500&fit=crop",
      "audioUrl": "https://example.com/audio/ocean-waves.mp3",
    },
    {
      "id": 4,
      "title": "Urban Rhythm",
      "artist": "City Beats",
      "album": "Street Symphony",
      "duration": "3:22",
      "imageUrl":
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=500&h=500&fit=crop",
      "audioUrl": "https://example.com/audio/urban-rhythm.mp3",
    },
    {
      "id": 5,
      "title": "Cosmic Journey",
      "artist": "Space Odyssey",
      "album": "Interstellar",
      "duration": "5:47",
      "imageUrl":
          "https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=500&h=500&fit=crop",
      "audioUrl": "https://example.com/audio/cosmic-journey.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _simulatePlayback();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _backgroundAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.surface,
      end: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  void _simulatePlayback() {
    // Simulate audio playback progress
    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isPlaying) {
          setState(() {
            _currentPosition = Duration(
              seconds: _currentPosition.inSeconds + 1,
            );
            if (_currentPosition >= _totalDuration) {
              _onNext();
            }
          });
          _simulatePlayback();
        }
      });
    }
  }

  Map<String, dynamic> get _currentTrack => _audioTracks[_currentTrackIndex];

  void _onPlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _backgroundController.forward();
      _simulatePlayback();
    } else {
      _backgroundController.reverse();
    }
    HapticFeedback.mediumImpact();
  }

  void _onPrevious() {
    setState(() {
      _currentTrackIndex = _currentTrackIndex > 0
          ? _currentTrackIndex - 1
          : _audioTracks.length - 1;
      _currentPosition = Duration.zero;
      _totalDuration = Duration(
        minutes: int.parse(_currentTrack["duration"].split(':')[0]),
        seconds: int.parse(_currentTrack["duration"].split(':')[1]),
      );
    });
    HapticFeedback.lightImpact();
  }

  void _onNext() {
    setState(() {
      _currentTrackIndex = (_currentTrackIndex + 1) % _audioTracks.length;
      _currentPosition = Duration.zero;
      _totalDuration = Duration(
        minutes: int.parse(_currentTrack["duration"].split(':')[0]),
        seconds: int.parse(_currentTrack["duration"].split(':')[1]),
      );
    });
    HapticFeedback.lightImpact();
  }

  void _onShuffle() {
    setState(() {
      _isShuffled = !_isShuffled;
    });
    HapticFeedback.lightImpact();
  }

  void _onRepeat() {
    setState(() {
      _isRepeated = !_isRepeated;
    });
    HapticFeedback.lightImpact();
  }

  void _onSeek(Duration position) {
    setState(() {
      _currentPosition = position;
    });
  }

  void _onVolumeChanged(double volume) {
    setState(() {
      _volume = volume;
    });
  }

  void _showMiniPlayerOverlay() {
    setState(() {
      _showMiniPlayer = true;
    });
    _slideController.forward();
  }

  void _hideMiniPlayerOverlay() {
    _slideController.reverse().then((_) {
      setState(() {
        _showMiniPlayer = false;
      });
    });
  }

  void _onBackPressed() {
    if (_showMiniPlayer) {
      _hideMiniPlayerOverlay();
    } else {
      _showMiniPlayerOverlay();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        body: Stack(
          children: [
            // Main audio player interface
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _backgroundAnimation.value ??
                            AppTheme.lightTheme.colorScheme.surface,
                        AppTheme.lightTheme.colorScheme.surface,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // App bar
                        Container(
                          width: double.infinity,
                          height: 8.h,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _onBackPressed,
                                child: Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.surface
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(5.w),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'keyboard_arrow_down',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                              Text(
                                'Now Playing',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.surface
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(5.w),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'more_vert',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    size: 5.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Album artwork
                        Expanded(
                          flex: 3,
                          child: AlbumArtworkWidget(
                            imageUrl: _currentTrack["imageUrl"] as String,
                            isPlaying: _isPlaying,
                            onTap: _onPlayPause,
                          ),
                        ),
                        // Track information
                        Expanded(
                          flex: 1,
                          child: TrackInfoWidget(
                            title: _currentTrack["title"] as String,
                            artist: _currentTrack["artist"] as String,
                            album: _currentTrack["album"] as String,
                          ),
                        ),
                        // Progress slider
                        ProgressSliderWidget(
                          currentPosition: _currentPosition,
                          totalDuration: _totalDuration,
                          onSeek: _onSeek,
                        ),
                        // Volume control
                        VolumeControlWidget(
                          volume: _volume,
                          onVolumeChanged: _onVolumeChanged,
                        ),
                        // Playback controls
                        Expanded(
                          flex: 2,
                          child: PlaybackControlsWidget(
                            isPlaying: _isPlaying,
                            onPlayPause: _onPlayPause,
                            onPrevious: _onPrevious,
                            onNext: _onNext,
                            onShuffle: _onShuffle,
                            onRepeat: _onRepeat,
                            isShuffled: _isShuffled,
                            isRepeated: _isRepeated,
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Mini player overlay
            if (_showMiniPlayer)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: MiniPlayerWidget(
                    title: _currentTrack["title"] as String,
                    artist: _currentTrack["artist"] as String,
                    imageUrl: _currentTrack["imageUrl"] as String,
                    isPlaying: _isPlaying,
                    onPlayPause: _onPlayPause,
                    onNext: _onNext,
                    onExpand: _hideMiniPlayerOverlay,
                    onClose: _hideMiniPlayerOverlay,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
