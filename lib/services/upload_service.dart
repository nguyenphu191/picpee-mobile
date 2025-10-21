import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;

enum UploadType { AVATAR, CHAT, ORDER_COMMENT, ARTICLE }

class UploadService {
  final Dio _dio;
  final String baseUrl = Url.baseUrl;

  UploadService({Dio? dio}) : _dio = dio ?? Dio();

  /// Upload single file
  /// Returns the uploaded file URL or null if failed
  Future<String?> uploadFile({
    required File file,
    required UploadType type,
    String? token,
    Function(int sent, int total)? onUploadProgress,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final mimeType = lookupMimeType(file.path);

      FormData formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
        'type': type.name,
      });

      final response = await _dio.post(
        '$baseUrl/common/file/upload',
        data: formData,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
        onSendProgress: onUploadProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data != null && data['data'] != null && data['data'] is List) {
          final urls = List<String>.from(data['data']);
          return urls.isNotEmpty ? urls.first : null;
        }
      }
      return null;
    } on DioException catch (e) {
      print('Upload error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
      }
      return null;
    } catch (e) {
      print('Unexpected upload error: $e');
      return null;
    }
  }

  /// Upload multiple files
  /// Returns list of uploaded file URLs
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    required UploadType type,
    String? token,
    Function(int sent, int total)? onUploadProgress,
  }) async {
    try {
      List<MultipartFile> multipartFiles = [];

      for (File file in files) {
        final fileName = file.path.split('/').last;
        final mimeType = lookupMimeType(file.path);

        multipartFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        );
      }

      FormData formData = FormData.fromMap({
        'files': multipartFiles,
        'type': type.name,
      });

      final response = await _dio.post(
        '$baseUrl/common/file/upload',
        data: formData,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
        onSendProgress: onUploadProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data != null && data['data'] != null && data['data'] is List) {
          return List<String>.from(data['data']);
        }
      }
      return [];
    } on DioException catch (e) {
      print('Upload multiple files error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
      }
      return [];
    } catch (e) {
      print('Unexpected upload error: $e');
      return [];
    }
  }

  /// Upload avatar specifically
  /// This is a convenience method for avatar uploads
  Future<String?> uploadAvatar({
    required File file,
    String? token,
    Function(int sent, int total)? onUploadProgress,
  }) async {
    return uploadFile(
      file: file,
      type: UploadType.AVATAR,
      token: token,
      onUploadProgress: onUploadProgress,
    );
  }

  /// Upload chat image
  Future<String?> uploadChatImage({
    required File file,
    String? token,
    Function(int sent, int total)? onUploadProgress,
  }) async {
    return uploadFile(
      file: file,
      type: UploadType.CHAT,
      token: token,
      onUploadProgress: onUploadProgress,
    );
  }

  /// Upload order comment image
  Future<String?> uploadOrderCommentImage({
    required File file,
    String? token,
    Function(int sent, int total)? onUploadProgress,
  }) async {
    return uploadFile(
      file: file,
      type: UploadType.ORDER_COMMENT,
      token: token,
      onUploadProgress: onUploadProgress,
    );
  }

  /// Upload article image
  Future<String?> uploadArticleImage({
    required File file,
    String? token,
    Function(int sent, int total)? onUploadProgress,
  }) async {
    return uploadFile(
      file: file,
      type: UploadType.ARTICLE,
      token: token,
      onUploadProgress: onUploadProgress,
    );
  }

  /// Upload multiple chat images
  Future<List<String>> uploadChatImages({
    required List<File> files,
    String? token,
    Function(int sent, int total)? onUploadProgress,
  }) async {
    return uploadMultipleFiles(
      files: files,
      type: UploadType.CHAT,
      token: token,
      onUploadProgress: onUploadProgress,
    );
  }

  void cancelUpload() {
    _dio.close(force: true);
  }
}
