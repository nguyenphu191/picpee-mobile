import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:picpee_mobile/services/upload_service.dart';

class UploadProvider with ChangeNotifier {
  final UploadService _uploadService = UploadService();

  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _uploadedUrl;
  List<String> _uploadedUrls = [];
  String? _errorMessage;

  // Getters
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;
  String? get uploadedUrl => _uploadedUrl;
  List<String> get uploadedUrls => _uploadedUrls;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Upload single file
  Future<String?> uploadFile({
    required File file,
    required UploadType type,
    String? token,
  }) async {
    try {
      _isUploading = true;
      _uploadProgress = 0.0;
      _errorMessage = null;
      _uploadedUrl = null;
      notifyListeners();

      final url = await _uploadService.uploadFile(
        file: file,
        type: type,
        token: token,
        onUploadProgress: (sent, total) {
          _uploadProgress = sent / total;
          notifyListeners();
        },
      );

      if (url != null) {
        _uploadedUrl = url;
        _uploadProgress = 1.0;
      } else {
        _errorMessage = 'Failed to upload file';
      }

      _isUploading = false;
      notifyListeners();
      return url;
    } catch (e) {
      _isUploading = false;
      _errorMessage = 'Upload error: $e';
      notifyListeners();
      return null;
    }
  }

  /// Upload multiple files
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    required UploadType type,
    String? token,
  }) async {
    try {
      _isUploading = true;
      _uploadProgress = 0.0;
      _errorMessage = null;
      _uploadedUrls = [];
      notifyListeners();

      final urls = await _uploadService.uploadMultipleFiles(
        files: files,
        type: type,
        token: token,
        onUploadProgress: (sent, total) {
          _uploadProgress = sent / total;
          notifyListeners();
        },
      );

      if (urls.isNotEmpty) {
        _uploadedUrls = urls;
        _uploadProgress = 1.0;
      } else {
        _errorMessage = 'Failed to upload files';
      }

      _isUploading = false;
      notifyListeners();
      return urls;
    } catch (e) {
      _isUploading = false;
      _errorMessage = 'Upload error: $e';
      notifyListeners();
      return [];
    }
  }

  /// Upload avatar
  Future<String?> uploadAvatar({required File file, String? token}) async {
    return uploadFile(file: file, type: UploadType.AVATAR, token: token);
  }

  /// Upload chat image
  Future<String?> uploadChatImage({required File file, String? token}) async {
    return uploadFile(file: file, type: UploadType.CHAT, token: token);
  }

  /// Upload order comment image
  Future<String?> uploadOrderCommentImage({
    required File file,
    String? token,
  }) async {
    return uploadFile(file: file, type: UploadType.ORDER_COMMENT, token: token);
  }

  /// Upload article image
  Future<String?> uploadArticleImage({
    required File file,
    String? token,
  }) async {
    return uploadFile(file: file, type: UploadType.ARTICLE, token: token);
  }

  /// Upload multiple chat images
  Future<List<String>> uploadChatImages({
    required List<File> files,
    String? token,
  }) async {
    return uploadMultipleFiles(
      files: files,
      type: UploadType.CHAT,
      token: token,
    );
  }

  /// Reset state
  void reset() {
    _isUploading = false;
    _uploadProgress = 0.0;
    _uploadedUrl = null;
    _uploadedUrls = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Cancel upload
  void cancelUpload() {
    _uploadService.cancelUpload();
    _isUploading = false;
    _uploadProgress = 0.0;
    notifyListeners();
  }
}
