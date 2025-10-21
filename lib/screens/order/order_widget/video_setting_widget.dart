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

  final List<String> aspectRatios = ['16:9 (Phone/Widescreen)', '4:3'];

  final List<String> resolutions = ['1080p', '720p'];

  final List<String> framerates = ['30 FPS', '60 FPS'];

  final List<String> fileTypes = ['MP4', 'MP3'];

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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
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
          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aspect Ratio',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
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
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resolution',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
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
          SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Framerate',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
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
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Type',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
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
          SizedBox(height: 5.h),

          // Checkboxes
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              'I have source with multiple frame rates',
              style: TextStyle(
                fontSize: 12.h,
                color: Colors.black87,
                height: 1.3,
              ),
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
              style: TextStyle(
                fontSize: 12.h,
                color: Colors.black87,
                height: 1.3,
              ),
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
