class VideoSettings {
  String aspectRatio;
  String resolution;
  String framerate;
  String fileType;
  String orientation;
  bool hasMultipleFrameRates;
  bool needsSlowDown;

  VideoSettings({
    this.aspectRatio = '16:9 (Phone/Widescreen)',
    this.resolution = '1080p',
    this.framerate = '30 FPS',
    this.fileType = 'MP4',
    this.orientation = 'HORIZONTAL',
    this.hasMultipleFrameRates = false,
    this.needsSlowDown = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'aspectRatio': aspectRatio == '16:9 (Phone/Widescreen)' ? '1' : '2',
      'resolution': resolution == '1080p' ? '1' : '2',
      'framerate': framerate == '30 FPS' ? '1' : '2',
      'fileType': fileType == 'MP4' ? '1' : '2',
      'orientationType': orientation,
      'hasMultipleFrameRates': hasMultipleFrameRates,
      'hasHighFrameRateFootage': needsSlowDown,
    };
  }

  factory VideoSettings.fromJson(Map<String, dynamic> json) {
    return VideoSettings(
      aspectRatio: json['aspectRatio'] ?? '16:9 (Phone/Widescreen)',
      resolution: json['resolution'] ?? '1080p',
      framerate: json['framerate'] ?? '30 FPS',
      fileType: json['fileType'] ?? 'MP4',
      orientation: json['orientationType'] ?? 'HORIZONTAL',
      hasMultipleFrameRates: json['hasMultipleFrameRates'] ?? false,
      needsSlowDown: json['hasHighFrameRateFootage'] ?? false,
    );
  }
}
