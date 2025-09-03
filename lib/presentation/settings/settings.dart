import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/storage_info_widget.dart';
import './widgets/subtitle_preview_widget.dart';
import './widgets/theme_selector_widget.dart';
import './widgets/user_profile_widget.dart';
import 'widgets/settings_item_widget.dart';
import 'widgets/settings_section_widget.dart';
import 'widgets/storage_info_widget.dart';
import 'widgets/subtitle_preview_widget.dart';
import 'widgets/theme_selector_widget.dart';
import 'widgets/user_profile_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  late TabController _tabController;

  // Section expansion states
  final Map<String, bool> _sectionExpanded = {
    'playback': true,
    'display': false,
    'audio': false,
    'subtitles': false,
    'storage': false,
    'about': false,
  };

  // Settings values
  final Map<String, dynamic> _settings = {
    'defaultQuality': 'Auto',
    'autoPlayNext': true,
    'crossfadeDuration': 3.0,
    'sleepTimer': false,
    'sleepTimerMinutes': 30,
    'playerOrientationLock': false,
    'gestureSensitivity': 0.7,
    'equalizerPreset': 'Normal',
    'volumeNormalization': true,
    'outputDevice': 'Default',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSection(String section) {
    setState(() {
      _sectionExpanded[section] = !_sectionExpanded[section]!;
    });
  }

  void _showSleepTimerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedMinutes = _settings['sleepTimerMinutes'];
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                "Sleep Timer",
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Auto-pause after: $selectedMinutes minutes",
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 2.h),
                  Slider(
                    value: selectedMinutes.toDouble(),
                    min: 5.0,
                    max: 120.0,
                    divisions: 23,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedMinutes = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _settings['sleepTimerMinutes'] = selectedMinutes;
                      _settings['sleepTimer'] = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Set Timer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Settings",
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 1.h),

                    // User Profile Section
                    const UserProfileWidget(),

                    SizedBox(height: 2.h),

                    // Playback Section
                    SettingsSectionWidget(
                      title: "Playback",
                      isExpanded: _sectionExpanded['playback']!,
                      onToggle: () => _toggleSection('playback'),
                      children: [
                        SettingsItemWidget(
                          title: "Default Quality",
                          subtitle: _settings['defaultQuality'],
                          leading: CustomIconWidget(
                            iconName: 'high_quality',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          onTap: () => _showQualitySelector(),
                        ),
                        SettingsItemWidget(
                          title: "Auto-play Next",
                          subtitle: "Automatically play next video in playlist",
                          leading: CustomIconWidget(
                            iconName: 'skip_next',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          trailing: Switch(
                            value: _settings['autoPlayNext'],
                            onChanged: (value) {
                              setState(() {
                                _settings['autoPlayNext'] = value;
                              });
                            },
                          ),
                        ),
                        SettingsItemWidget(
                          title: "Crossfade Duration",
                          subtitle:
                              "${_settings['crossfadeDuration'].toInt()} seconds",
                          leading: CustomIconWidget(
                            iconName: 'tune',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          onTap: () => _showCrossfadeSlider(),
                        ),
                        SettingsItemWidget(
                          title: "Sleep Timer",
                          subtitle: _settings['sleepTimer']
                              ? "Active (${_settings['sleepTimerMinutes']} min)"
                              : "Inactive",
                          leading: CustomIconWidget(
                            iconName: 'bedtime',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          trailing: Switch(
                            value: _settings['sleepTimer'],
                            onChanged: (value) {
                              if (value) {
                                _showSleepTimerDialog();
                              } else {
                                setState(() {
                                  _settings['sleepTimer'] = false;
                                });
                              }
                            },
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),

                    // Display Section
                    SettingsSectionWidget(
                      title: "Display",
                      isExpanded: _sectionExpanded['display']!,
                      onToggle: () => _toggleSection('display'),
                      children: [
                        const ThemeSelectorWidget(),
                        Divider(
                          color: AppTheme.lightTheme.dividerColor,
                          height: 1,
                          indent: 4.w,
                          endIndent: 4.w,
                        ),
                        SettingsItemWidget(
                          title: "Player Orientation Lock",
                          subtitle: "Lock video player to landscape mode",
                          leading: CustomIconWidget(
                            iconName: 'screen_rotation',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          trailing: Switch(
                            value: _settings['playerOrientationLock'],
                            onChanged: (value) {
                              setState(() {
                                _settings['playerOrientationLock'] = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gesture Sensitivity: ${(_settings['gestureSensitivity'] * 100).toInt()}%",
                                style: AppTheme.lightTheme.textTheme.bodyLarge,
                              ),
                              SizedBox(height: 1.h),
                              Slider(
                                value: _settings['gestureSensitivity'],
                                min: 0.1,
                                max: 1.0,
                                divisions: 9,
                                onChanged: (value) {
                                  setState(() {
                                    _settings['gestureSensitivity'] = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Audio Section
                    SettingsSectionWidget(
                      title: "Audio",
                      isExpanded: _sectionExpanded['audio']!,
                      onToggle: () => _toggleSection('audio'),
                      children: [
                        SettingsItemWidget(
                          title: "Equalizer Preset",
                          subtitle: _settings['equalizerPreset'],
                          leading: CustomIconWidget(
                            iconName: 'equalizer',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          onTap: () => _showEqualizerPresets(),
                        ),
                        SettingsItemWidget(
                          title: "Volume Normalization",
                          subtitle: "Maintain consistent volume across tracks",
                          leading: CustomIconWidget(
                            iconName: 'volume_up',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          trailing: Switch(
                            value: _settings['volumeNormalization'],
                            onChanged: (value) {
                              setState(() {
                                _settings['volumeNormalization'] = value;
                              });
                            },
                          ),
                        ),
                        SettingsItemWidget(
                          title: "Output Device",
                          subtitle: _settings['outputDevice'],
                          leading: CustomIconWidget(
                            iconName: 'headphones',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          onTap: () => _showOutputDevices(),
                          showDivider: false,
                        ),
                      ],
                    ),

                    // Subtitles Section
                    SettingsSectionWidget(
                      title: "Subtitles",
                      isExpanded: _sectionExpanded['subtitles']!,
                      onToggle: () => _toggleSection('subtitles'),
                      children: [
                        const SubtitlePreviewWidget(),
                      ],
                    ),

                    // Storage Section
                    SettingsSectionWidget(
                      title: "Storage",
                      isExpanded: _sectionExpanded['storage']!,
                      onToggle: () => _toggleSection('storage'),
                      children: [
                        const StorageInfoWidget(),
                      ],
                    ),

                    // About Section
                    SettingsSectionWidget(
                      title: "About",
                      isExpanded: _sectionExpanded['about']!,
                      onToggle: () => _toggleSection('about'),
                      children: [
                        SettingsItemWidget(
                          title: "Version",
                          subtitle: "Neon Play v2.1.0 (Build 2025030319)",
                          leading: CustomIconWidget(
                            iconName: 'info',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        SettingsItemWidget(
                          title: "Privacy Policy",
                          leading: CustomIconWidget(
                            iconName: 'privacy_tip',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          onTap: () =>
                              _launchUrl('https://neonplay.app/privacy'),
                        ),
                        SettingsItemWidget(
                          title: "Terms of Service",
                          leading: CustomIconWidget(
                            iconName: 'description',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          onTap: () => _launchUrl('https://neonplay.app/terms'),
                        ),
                        SettingsItemWidget(
                          title: "Support",
                          subtitle: "Get help and contact support",
                          leading: CustomIconWidget(
                            iconName: 'support',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          onTap: () =>
                              _launchUrl('mailto:support@neonplay.app'),
                          showDivider: false,
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: Colors.transparent,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/splash-screen');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/media-library-home');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/video-player');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/audio-player');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/playlist-management');
                break;
              case 5:
                // Current screen - Settings
                break;
            }
          },
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'home',
                color: _tabController.index == 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              text: "Home",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'library_music',
                color: _tabController.index == 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              text: "Library",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'play_circle',
                color: _tabController.index == 2
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              text: "Video",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'audiotrack',
                color: _tabController.index == 3
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              text: "Audio",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'playlist_play',
                color: _tabController.index == 4
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              text: "Playlists",
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: _tabController.index == 5
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              text: "Settings",
            ),
          ],
        ),
      ),
    );
  }

  void _showQualitySelector() {
    final qualities = [
      'Auto',
      '144p',
      '240p',
      '360p',
      '480p',
      '720p',
      '1080p',
      '4K'
    ];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Default Quality",
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ...qualities.map((quality) {
                final isSelected = _settings['defaultQuality'] == quality;
                return ListTile(
                  title: Text(quality),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _settings['defaultQuality'] = quality;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showCrossfadeSlider() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double currentValue = _settings['crossfadeDuration'];
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                "Crossfade Duration",
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${currentValue.toInt()} seconds",
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 2.h),
                  Slider(
                    value: currentValue,
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                    onChanged: (value) {
                      setDialogState(() {
                        currentValue = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _settings['crossfadeDuration'] = currentValue;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEqualizerPresets() {
    final presets = [
      'Normal',
      'Rock',
      'Pop',
      'Jazz',
      'Classical',
      'Electronic',
      'Hip Hop',
      'Custom'
    ];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Equalizer Preset",
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ...presets.map((preset) {
                final isSelected = _settings['equalizerPreset'] == preset;
                return ListTile(
                  title: Text(preset),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _settings['equalizerPreset'] = preset;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showOutputDevices() {
    final devices = [
      'Default',
      'Phone Speaker',
      'Wired Headphones',
      'Bluetooth Headphones',
      'External Speaker'
    ];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Output Device",
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ...devices.map((device) {
                final isSelected = _settings['outputDevice'] == device;
                return ListTile(
                  title: Text(device),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _settings['outputDevice'] = device;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _launchUrl(String url) {
    // In a real app, you would use url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Opening: $url",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}