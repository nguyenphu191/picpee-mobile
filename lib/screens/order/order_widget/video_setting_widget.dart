import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/models/video_setting.dart';

class VideoSettingsWidget extends StatefulWidget {
  final VideoSettings settings;
  final ValueChanged<VideoSettings> onChanged;

  const VideoSettingsWidget({
    Key? key,
    required this.settings,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<VideoSettingsWidget> createState() => _VideoSettingsWidgetState();
}

class _VideoSettingsWidgetState extends State<VideoSettingsWidget> {
  late VideoSettings _settings;

  final List<String> aspectRatios = [
    '16:9 (Phone/Widescreen)',
    '9:16 (Vertical/Stories)',
    '1:1 (Square)',
    '4:3 (Standard)',
    '21:9 (Ultrawide)',
  ];

  final List<String> resolutions = ['480p', '720p', '1080p', '2K', '4K', '8K'];

  final List<String> framerates = ['24 FPS', '30 FPS', '60 FPS', '120 FPS'];

  final List<String> fileTypes = ['MP4', 'MOV', 'AVI', 'MKV', 'WEBM'];

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  void _updateSettings() {
    widget.onChanged(_settings);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Video Specifications',
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),

          // Row 1: Aspect Ratio and Resolution
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aspect Ratio',
                      style: TextStyle(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: _settings.aspectRatio,
                        items: aspectRatios.map((ratio) {
                          return DropdownMenuItem<String>(
                            value: ratio,
                            child: Text(
                              ratio,
                              style: TextStyle(fontSize: 13.h),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _settings.aspectRatio = value;
                            });
                            _updateSettings();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resolution',
                      style: TextStyle(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: _settings.resolution,
                        items: resolutions.map((res) {
                          return DropdownMenuItem<String>(
                            value: res,
                            child: Text(res, style: TextStyle(fontSize: 13.h)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _settings.resolution = value;
                            });
                            _updateSettings();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Row 2: Framerate and File Type
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Framerate',
                      style: TextStyle(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: _settings.framerate,
                        items: framerates.map((fps) {
                          return DropdownMenuItem<String>(
                            value: fps,
                            child: Text(fps, style: TextStyle(fontSize: 13.h)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _settings.framerate = value;
                            });
                            _updateSettings();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Type',
                      style: TextStyle(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        value: _settings.fileType,
                        items: fileTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type, style: TextStyle(fontSize: 13.h)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _settings.fileType = value;
                            });
                            _updateSettings();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Checkboxes
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              'I have source with multiple frame rates',
              style: TextStyle(fontSize: 13.h, color: Colors.black87),
            ),
            value: _settings.hasMultipleFrameRates,
            onChanged: (value) {
              setState(() {
                _settings.hasMultipleFrameRates = value ?? false;
              });
              _updateSettings();
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              'I have high framerate footage that needs to be slowed down',
              style: TextStyle(fontSize: 13.h, color: Colors.black87),
            ),
            value: _settings.needsSlowDown,
            onChanged: (value) {
              setState(() {
                _settings.needsSlowDown = value ?? false;
              });
              _updateSettings();
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }
}
