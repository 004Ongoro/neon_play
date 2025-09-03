import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/context_menu_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/media_card_widget.dart';
import './widgets/recent_media_card_widget.dart';
import './widgets/search_bar_widget.dart';

class MediaLibraryHome extends StatefulWidget {
  const MediaLibraryHome({Key? key}) : super(key: key);

  @override
  State<MediaLibraryHome> createState() => _MediaLibraryHomeState();
}

class _MediaLibraryHomeState extends State<MediaLibraryHome>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  String _selectedFilter = 'All';
  bool _isGridView = true;
  bool _isRefreshing = false;
  Map<String, dynamic>? _selectedMediaForContext;
  List<Map<String, dynamic>> _filteredMediaList = [];

  // Mock data for media library
  final List<Map<String, dynamic>> _mediaLibrary = [
    {
      "id": 1,
      "title": "Epic Movie Trailer 2024",
      "duration": "2:45",
      "format": "MP4",
      "type": "video",
      "thumbnail":
          "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg?auto=compress&cs=tinysrgb&w=800",
      "progress": 0.3,
      "lastPlayed": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "title": "Relaxing Piano Music",
      "duration": "45:30",
      "format": "MP3",
      "type": "audio",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/11/29/13/14/attractive-1869761_1280.jpg?auto=compress&cs=tinysrgb&w=800",
      "progress": 0.7,
      "lastPlayed": DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      "id": 3,
      "title": "Nature Documentary",
      "duration": "58:12",
      "format": "MKV",
      "type": "video",
      "thumbnail":
          "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=compress&cs=tinysrgb&w=800",
      "progress": 0.1,
      "lastPlayed": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 4,
      "title": "Podcast Episode 42",
      "duration": "1:23:45",
      "format": "M4A",
      "type": "audio",
      "thumbnail":
          "https://images.pexels.com/photos/7130560/pexels-photo-7130560.jpeg?auto=compress&cs=tinysrgb&w=800",
      "progress": 0.0,
      "lastPlayed": null,
    },
    {
      "id": 5,
      "title": "Cooking Tutorial",
      "duration": "15:20",
      "format": "AVI",
      "type": "video",
      "thumbnail":
          "https://images.pixabay.com/photo/2017/05/11/19/44/fresh-2305192_1280.jpg?auto=compress&cs=tinysrgb&w=800",
      "progress": 0.5,
      "lastPlayed": DateTime.now().subtract(const Duration(hours: 12)),
    },
    {
      "id": 6,
      "title": "Jazz Collection",
      "duration": "2:15:30",
      "format": "FLAC",
      "type": "audio",
      "thumbnail":
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=compress&cs=tinysrgb&w=800",
      "progress": 0.2,
      "lastPlayed": DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  final List<Map<String, String>> _filterOptions = [
    {"label": "All", "icon": "apps"},
    {"label": "Video", "icon": "videocam"},
    {"label": "Audio", "icon": "music_note"},
    {"label": "Recent", "icon": "history"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredMediaList = List.from(_mediaLibrary);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterMedia();
  }

  void _filterMedia() {
    setState(() {
      _filteredMediaList = _mediaLibrary.where((media) {
        final matchesSearch = _searchController.text.isEmpty ||
            (media['title'] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Video' && media['type'] == 'video') ||
            (_selectedFilter == 'Audio' && media['type'] == 'audio') ||
            (_selectedFilter == 'Recent' && media['lastPlayed'] != null);

        return matchesSearch && matchesFilter;
      }).toList();

      if (_selectedFilter == 'Recent') {
        _filteredMediaList.sort((a, b) {
          final aTime = a['lastPlayed'] as DateTime?;
          final bTime = b['lastPlayed'] as DateTime?;
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate scanning for new media files
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Media library refreshed'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onMediaTap(Map<String, dynamic> media) {
    final String type = media['type'] as String;
    if (type == 'video') {
      Navigator.pushNamed(context, '/video-player');
    } else {
      Navigator.pushNamed(context, '/audio-player');
    }
  }

  void _onMediaLongPress(Map<String, dynamic> media) {
    setState(() {
      _selectedMediaForContext = media;
    });
  }

  void _dismissContextMenu() {
    setState(() {
      _selectedMediaForContext = null;
    });
  }

  void _showImportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Import Media',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildImportOption(
              icon: 'photo_library',
              title: 'Camera Roll',
              subtitle: 'Import from your photos and videos',
              onTap: () {
                Navigator.pop(context);
                // Handle camera roll import
              },
            ),
            _buildImportOption(
              icon: 'folder',
              title: 'Browse Files',
              subtitle: 'Select files from device storage',
              onTap: () {
                Navigator.pop(context);
                // Handle file browser
              },
            ),
            _buildImportOption(
              icon: 'cloud_upload',
              title: 'Cloud Storage',
              subtitle: 'Import from Google Drive, Dropbox',
              onTap: () {
                Navigator.pop(context);
                // Handle cloud storage
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImportOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.accent,
                size: 24,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _recentlyPlayed {
    return _mediaLibrary.where((media) => media['lastPlayed'] != null).toList()
      ..sort((a, b) {
        final aTime = a['lastPlayed'] as DateTime;
        final bTime = b['lastPlayed'] as DateTime;
        return bTime.compareTo(aTime);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header with search and view toggle
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              controller: _searchController,
                              onChanged: (value) => _filterMedia(),
                              onClear: () {
                                _searchController.clear();
                                _filterMedia();
                              },
                            ),
                          ),
                          SizedBox(width: 3.w),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isGridView = !_isGridView;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2.5.w),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CustomIconWidget(
                                iconName:
                                    _isGridView ? 'view_list' : 'grid_view',
                                color: AppTheme.accent,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // Filter chips
                      SizedBox(
                        height: 5.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filterOptions.length,
                          itemBuilder: (context, index) {
                            final filter = _filterOptions[index];
                            return FilterChipWidget(
                              label: filter['label']!,
                              iconName: filter['icon']!,
                              isSelected: _selectedFilter == filter['label'],
                              onTap: () {
                                setState(() {
                                  _selectedFilter = filter['label']!;
                                });
                                _filterMedia();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppTheme.accent,
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    child: _filteredMediaList.isEmpty
                        ? EmptyStateWidget(onImportTap: _showImportOptions)
                        : CustomScrollView(
                            slivers: [
                              // Recently played section
                              if (_recentlyPlayed.isNotEmpty &&
                                  _selectedFilter == 'All') ...[
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'history',
                                          color: AppTheme.accent,
                                          size: 20,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          'Recently Played',
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 35.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      itemCount: _recentlyPlayed.take(5).length,
                                      itemBuilder: (context, index) {
                                        final media = _recentlyPlayed[index];
                                        return RecentMediaCardWidget(
                                          mediaItem: media,
                                          onTap: () => _onMediaTap(media),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'video_library',
                                          color: AppTheme.accent,
                                          size: 20,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          'All Media',
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              // Media grid/list
                              _isGridView
                                  ? SliverPadding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      sliver: SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.75,
                                          crossAxisSpacing: 2.w,
                                          mainAxisSpacing: 2.w,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final media =
                                                _filteredMediaList[index];
                                            return MediaCardWidget(
                                              mediaItem: media,
                                              onTap: () => _onMediaTap(media),
                                              onLongPress: () =>
                                                  _onMediaLongPress(media),
                                            );
                                          },
                                          childCount: _filteredMediaList.length,
                                        ),
                                      ),
                                    )
                                  : SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          final media =
                                              _filteredMediaList[index];
                                          return MediaCardWidget(
                                            mediaItem: media,
                                            onTap: () => _onMediaTap(media),
                                            onLongPress: () =>
                                                _onMediaLongPress(media),
                                          );
                                        },
                                        childCount: _filteredMediaList.length,
                                      ),
                                    ),
                              // Bottom padding
                              SliverToBoxAdapter(
                                child: SizedBox(height: 10.h),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            // Bottom navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      icon: CustomIconWidget(
                        iconName: 'video_library',
                        color: _tabController.index == 0
                            ? AppTheme.accent
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 24,
                      ),
                      text: 'Library',
                    ),
                    Tab(
                      icon: CustomIconWidget(
                        iconName: 'playlist_play',
                        color: _tabController.index == 1
                            ? AppTheme.accent
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 24,
                      ),
                      text: 'Playlists',
                    ),
                    Tab(
                      icon: CustomIconWidget(
                        iconName: 'settings',
                        color: _tabController.index == 2
                            ? AppTheme.accent
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 24,
                      ),
                      text: 'Settings',
                    ),
                  ],
                  onTap: (index) {
                    if (index == 1) {
                      Navigator.pushNamed(context, '/playlist-management');
                    } else if (index == 2) {
                      Navigator.pushNamed(context, '/settings');
                    }
                  },
                ),
              ),
            ),
            // Floating action button
            Positioned(
              bottom: 12.h,
              right: 6.w,
              child: FloatingActionButton(
                onPressed: _showImportOptions,
                backgroundColor: AppTheme.accent,
                child: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            // Context menu overlay
            if (_selectedMediaForContext != null)
              ContextMenuWidget(
                mediaItem: _selectedMediaForContext!,
                onPlay: () => _onMediaTap(_selectedMediaForContext!),
                onAddToPlaylist: () {
                  Navigator.pushNamed(context, '/playlist-management');
                },
                onShare: () {
                  // Handle share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Share functionality coming soon'),
                      backgroundColor: AppTheme.accent,
                    ),
                  );
                },
                onDelete: () {
                  // Handle delete functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Delete functionality coming soon'),
                      backgroundColor: AppTheme.lightTheme.colorScheme.error,
                    ),
                  );
                },
                onDismiss: _dismissContextMenu,
              ),
          ],
        ),
      ),
    );
  }
}
