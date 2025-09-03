import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_toolbar_widget.dart';
import './widgets/empty_playlist_widget.dart';
import './widgets/playlist_header_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/track_item_widget.dart';

class PlaylistManagement extends StatefulWidget {
  const PlaylistManagement({Key? key}) : super(key: key);

  @override
  State<PlaylistManagement> createState() => _PlaylistManagementState();
}

class _PlaylistManagementState extends State<PlaylistManagement> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _isSearchVisible = false;
  bool _isShuffleEnabled = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _tracks = [];
  List<Map<String, dynamic>> _filteredTracks = [];

  // Mock playlist data
  String _playlistTitle = 'My Awesome Playlist';
  final String _artworkUrl =
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=400&fit=crop';
  String _totalDuration = '2h 34m';

  // Mock suggested tracks for empty state
  final List<Map<String, dynamic>> _suggestedTracks = [
    {
      'id': 'suggested_1',
      'title': 'Blinding Lights',
      'artist': 'The Weeknd',
      'duration': '3:20',
      'thumbnail':
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&h=200&fit=crop',
    },
    {
      'id': 'suggested_2',
      'title': 'Watermelon Sugar',
      'artist': 'Harry Styles',
      'duration': '2:54',
      'thumbnail':
          'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=200&h=200&fit=crop',
    },
    {
      'id': 'suggested_3',
      'title': 'Levitating',
      'artist': 'Dua Lipa',
      'duration': '3:23',
      'thumbnail':
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&h=200&fit=crop',
    },
    {
      'id': 'suggested_4',
      'title': 'Good 4 U',
      'artist': 'Olivia Rodrigo',
      'duration': '2:58',
      'thumbnail':
          'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=200&h=200&fit=crop',
    },
    {
      'id': 'suggested_5',
      'title': 'Stay',
      'artist': 'The Kid LAROI & Justin Bieber',
      'duration': '2:21',
      'thumbnail':
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&h=200&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    // Mock tracks data
    _tracks = [
      {
        'id': 1,
        'title': 'Bohemian Rhapsody',
        'artist': 'Queen',
        'duration': '5:55',
        'thumbnail':
            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&h=200&fit=crop',
      },
      {
        'id': 2,
        'title': 'Hotel California',
        'artist': 'Eagles',
        'duration': '6:30',
        'thumbnail':
            'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=200&h=200&fit=crop',
      },
      {
        'id': 3,
        'title': 'Stairway to Heaven',
        'artist': 'Led Zeppelin',
        'duration': '8:02',
        'thumbnail':
            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&h=200&fit=crop',
      },
      {
        'id': 4,
        'title': 'Sweet Child O\' Mine',
        'artist': 'Guns N\' Roses',
        'duration': '5:03',
        'thumbnail':
            'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=200&h=200&fit=crop',
      },
      {
        'id': 5,
        'title': 'Imagine',
        'artist': 'John Lennon',
        'duration': '3:07',
        'thumbnail':
            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&h=200&fit=crop',
      },
      {
        'id': 6,
        'title': 'Billie Jean',
        'artist': 'Michael Jackson',
        'duration': '4:54',
        'thumbnail':
            'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=200&h=200&fit=crop',
      },
      {
        'id': 7,
        'title': 'Purple Haze',
        'artist': 'Jimi Hendrix',
        'duration': '2:50',
        'thumbnail':
            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&h=200&fit=crop',
      },
      {
        'id': 8,
        'title': 'Yesterday',
        'artist': 'The Beatles',
        'duration': '2:05',
        'thumbnail':
            'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=200&h=200&fit=crop',
      },
    ];
    _filteredTracks = List.from(_tracks);
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isSearchVisible) {
      setState(() {
        _isSearchVisible = true;
      });
    } else if (_scrollController.offset <= 100 && _isSearchVisible) {
      setState(() {
        _isSearchVisible = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate metadata refresh
      _totalDuration = '2h 35m';
    });
    Fluttertoast.showToast(
      msg: "Playlist refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredTracks = List.from(_tracks);
      } else {
        _filteredTracks = _tracks.where((track) {
          final title = (track['title'] as String).toLowerCase();
          final artist = (track['artist'] as String).toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || artist.contains(searchLower);
        }).toList();
      }
    });
  }

  void _onSearchClear() {
    setState(() {
      _searchQuery = '';
      _filteredTracks = List.from(_tracks);
    });
  }

  void _onTitleChanged(String newTitle) {
    setState(() {
      _playlistTitle = newTitle;
    });
    Fluttertoast.showToast(
      msg: "Playlist title updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onDeleteTrack(Map<String, dynamic> track) {
    setState(() {
      _tracks.removeWhere((t) => t['id'] == track['id']);
      _filteredTracks.removeWhere((t) => t['id'] == track['id']);
    });
    HapticFeedback.mediumImpact();
    Fluttertoast.showToast(
      msg: "\"${track['title']}\" removed from playlist",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onAddToQueue(Map<String, dynamic> track) {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "\"${track['title']}\" added to queue",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onMoreOptions(Map<String, dynamic> track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.w,
              margin: EdgeInsets.symmetric(vertical: 2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'play_arrow',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
              title: Text(
                'Play Now',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/audio-player');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'queue_music',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
              title: Text(
                'Add to Queue',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _onAddToQueue(track);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
              title: Text(
                'Track Info',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showTrackInfo(track);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showTrackInfo(Map<String, dynamic> track) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Track Information',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${track['title']}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Artist: ${track['artist']}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Duration: ${track['duration']}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.accent),
            ),
          ),
        ],
      ),
    );
  }

  void _onShufflePlay() {
    setState(() {
      _isShuffleEnabled = !_isShuffleEnabled;
    });
    HapticFeedback.mediumImpact();
    if (_tracks.isNotEmpty) {
      Navigator.pushNamed(context, '/audio-player');
    } else {
      Fluttertoast.showToast(
        msg: "Add tracks to start playing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _onAddTracks() {
    Navigator.pushNamed(context, '/media-library-home');
  }

  void _onSharePlaylist() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Playlist shared successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onReorderTracks(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final track = _tracks.removeAt(oldIndex);
      _tracks.insert(newIndex, track);
      _filteredTracks = List.from(_tracks);
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: _tracks.isEmpty ? _buildEmptyState() : _buildPlaylistContent(),
      floatingActionButton: _tracks.isNotEmpty
          ? FloatingActionButton(
              onPressed: _onAddTracks,
              backgroundColor: AppTheme.accent,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return EmptyPlaylistWidget(
      onAddFirstTrack: _onAddTracks,
      suggestedTracks: _suggestedTracks,
    );
  }

  Widget _buildPlaylistContent() {
    return Column(
      children: [
        // Search bar (animated)
        SearchBarWidget(
          onSearchChanged: _onSearchChanged,
          isVisible: _isSearchVisible,
          onClear: _onSearchClear,
        ),
        // Main content
        Expanded(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _onRefresh,
            color: AppTheme.accent,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Playlist header
                SliverToBoxAdapter(
                  child: PlaylistHeaderWidget(
                    playlistTitle: _playlistTitle,
                    artworkUrl: _artworkUrl,
                    trackCount: _tracks.length,
                    totalDuration: _totalDuration,
                    onTitleChanged: _onTitleChanged,
                  ),
                ),
                // Tracks list
                SliverReorderableList(
                  itemCount: _filteredTracks.length,
                  onReorder: _onReorderTracks,
                  itemBuilder: (context, index) {
                    final track = _filteredTracks[index];
                    return ReorderableDelayedDragStartListener(
                      key: ValueKey(track['id']),
                      index: index,
                      child: TrackItemWidget(
                        track: track,
                        onDelete: () => _onDeleteTrack(track),
                        onAddToQueue: () => _onAddToQueue(track),
                        onMoreOptions: () => _onMoreOptions(track),
                      ),
                    );
                  },
                ),
                // Bottom spacing
                SliverToBoxAdapter(
                  child: SizedBox(height: 20.h),
                ),
              ],
            ),
          ),
        ),
        // Bottom toolbar
        BottomToolbarWidget(
          onShufflePlay: _onShufflePlay,
          onAddTracks: _onAddTracks,
          onSharePlaylist: _onSharePlaylist,
          isShuffleEnabled: _isShuffleEnabled,
        ),
      ],
    );
  }
}
