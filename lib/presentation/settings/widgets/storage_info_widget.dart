import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StorageInfoWidget extends StatefulWidget {
  const StorageInfoWidget({super.key});

  @override
  State<StorageInfoWidget> createState() => _StorageInfoWidgetState();
}

class _StorageInfoWidgetState extends State<StorageInfoWidget> {
  bool _isClearing = false;

  final Map<String, dynamic> _storageData = {
    'totalCache': 1.2,
    'videoCache': 0.8,
    'audioCache': 0.3,
    'thumbnails': 0.1,
    'autoCleanup': true,
    'cleanupDays': 7,
  };

  Future<void> _clearCache() async {
    setState(() {
      _isClearing = true;
    });

    // Simulate cache clearing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isClearing = false;
        _storageData['totalCache'] = 0.0;
        _storageData['videoCache'] = 0.0;
        _storageData['audioCache'] = 0.0;
        _storageData['thumbnails'] = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cache cleared successfully",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Clear Cache",
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            "This will clear ${_storageData['totalCache'].toStringAsFixed(1)} GB of cached data. This action cannot be undone.",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
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
                Navigator.of(context).pop();
                _clearCache();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warning,
              ),
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cache Size Overview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Cache Size",
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              Text(
                "${_storageData['totalCache'].toStringAsFixed(1)} GB",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Cache Breakdown
          _buildCacheItem(
              "Video Cache", _storageData['videoCache'], Icons.video_library),
          _buildCacheItem(
              "Audio Cache", _storageData['audioCache'], Icons.audiotrack),
          _buildCacheItem(
              "Thumbnails", _storageData['thumbnails'], Icons.image),
          SizedBox(height: 2.h),

          // Auto Cleanup Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Auto Cleanup",
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    Text(
                      "Automatically clear old cache files",
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch(
                value: _storageData['autoCleanup'],
                onChanged: (value) {
                  setState(() {
                    _storageData['autoCleanup'] = value;
                  });
                },
              ),
            ],
          ),

          if (_storageData['autoCleanup']) ...[
            SizedBox(height: 2.h),
            Text(
              "Cleanup after ${_storageData['cleanupDays']} days",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            Slider(
              value: _storageData['cleanupDays'].toDouble(),
              min: 1.0,
              max: 30.0,
              divisions: 29,
              label: "${_storageData['cleanupDays']} days",
              onChanged: (value) {
                setState(() {
                  _storageData['cleanupDays'] = value.toInt();
                });
              },
            ),
          ],

          SizedBox(height: 3.h),

          // Clear Cache Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _storageData['totalCache'] > 0 && !_isClearing
                  ? _showClearCacheDialog
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warning,
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: _isClearing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text("Clearing..."),
                      ],
                    )
                  : Text(
                      "Clear Cache (${_storageData['totalCache'].toStringAsFixed(1)} GB)",
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheItem(String title, double size, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon.toString().split('.').last,
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          Text(
            "${size.toStringAsFixed(1)} GB",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
