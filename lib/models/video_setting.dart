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
    this.orientation = 'Horizontal',
    this.hasMultipleFrameRates = false,
    this.needsSlowDown = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'aspectRatio': aspectRatio,
      'resolution': resolution,
      'framerate': framerate,
      'fileType': fileType,
      'orientation': orientation,
      'hasMultipleFrameRates': hasMultipleFrameRates,
      'needsSlowDown': needsSlowDown,
    };
  }

  factory VideoSettings.fromJson(Map<String, dynamic> json) {
    return VideoSettings(
      aspectRatio: json['aspectRatio'] ?? '16:9 (Phone/Widescreen)',
      resolution: json['resolution'] ?? '1080p',
      framerate: json['framerate'] ?? '30 FPS',
      fileType: json['fileType'] ?? 'MP4',
      orientation: json['orientation'] ?? 'Horizontal',
      hasMultipleFrameRates: json['hasMultipleFrameRates'] ?? false,
      needsSlowDown: json['needsSlowDown'] ?? false,
    );
  }
}
