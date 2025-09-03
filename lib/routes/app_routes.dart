import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/media_library_home/media_library_home.dart';
import '../presentation/audio_player/audio_player.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/playlist_management/playlist_management.dart';
import '../presentation/video_player/video_player.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String mediaLibraryHome = '/media-library-home';
  static const String audioPlayer = '/audio-player';
  static const String splash = '/splash-screen';
  static const String playlistManagement = '/playlist-management';
  static const String videoPlayer = '/video-player';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    settings: (context) => const Settings(),
    mediaLibraryHome: (context) => const MediaLibraryHome(),
    audioPlayer: (context) => const AudioPlayer(),
    splash: (context) => const SplashScreen(),
    playlistManagement: (context) => const PlaylistManagement(),
    videoPlayer: (context) => const VideoPlayer(),
    // TODO: Add your other routes here
  };
}
