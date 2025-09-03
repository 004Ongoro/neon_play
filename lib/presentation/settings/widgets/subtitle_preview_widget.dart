import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SubtitlePreviewWidget extends StatefulWidget {
  const SubtitlePreviewWidget({super.key});

  @override
  State<SubtitlePreviewWidget> createState() => _SubtitlePreviewWidgetState();
}

class _SubtitlePreviewWidgetState extends State<SubtitlePreviewWidget> {
  double _fontSize = 16.0;
  Color _textColor = Colors.white;
  double _backgroundOpacity = 0.7;
  String _position = 'Bottom';

  final List<Color> _colorOptions = [
    Colors.white,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Container
          Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1489599735734-79b4212f2371?w=800&h=400&fit=crop"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: _position == 'Bottom' ? 2.h : null,
                  top: _position == 'Top' ? 2.h : null,
                  left: 4.w,
                  right: 4.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: _backgroundOpacity),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "This is a sample subtitle text",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Font Size Slider
          Text(
            "Font Size: ${_fontSize.toInt()}sp",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Slider(
            value: _fontSize,
            min: 12.0,
            max: 24.0,
            divisions: 12,
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
          SizedBox(height: 2.h),

          // Text Color Selection
          Text(
            "Text Color",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 1.h),
          Row(
            children: _colorOptions.map((color) {
              final isSelected = _textColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _textColor = color;
                  });
                },
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 2.h),

          // Background Opacity Slider
          Text(
            "Background Opacity: ${(_backgroundOpacity * 100).toInt()}%",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Slider(
            value: _backgroundOpacity,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            onChanged: (value) {
              setState(() {
                _backgroundOpacity = value;
              });
            },
          ),
          SizedBox(height: 2.h),

          // Position Selection
          Text(
            "Position",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 1.h),
          Row(
            children: ['Bottom', 'Top'].map((position) {
              final isSelected = _position == position;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _position = position;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.dividerColor,
                      ),
                    ),
                    child: Text(
                      position,
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
