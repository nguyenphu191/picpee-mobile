import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleDriveService {
  static const _scopes = [drive.DriveApi.driveReadonlyScope];

  // Lấy folder ID từ URL
  static String? extractFolderId(String url) {
    final regex = RegExp(r'folders/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  // Lấy danh sách file từ folder (sử dụng API key - public access)
  static Future<List<DriveFile>> getFilesFromFolder(String folderUrl) async {
    try {
      final folderId = extractFolderId(folderUrl);
      if (folderId == null) {
        throw Exception('Invalid folder URL');
      }

      // Sử dụng API key cho public folders
      final apiKey =
          'AIzaSyBBK-YT2L3gefvsX3DG90Bs04ARlZ1QxdE'; // Thay bằng API key của bạn
      final url = Uri.parse(
        'https://www.googleapis.com/drive/v3/files?'
        'q=\'$folderId\'+in+parents+and+trashed=false&'
        'fields=files(id,name,mimeType,size,modifiedTime,webViewLink,thumbnailLink)&'
        'key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final files = (data['files'] as List)
            .map((file) => DriveFile.fromJson(file))
            .toList();
        return files;
      } else {
        throw Exception('Failed to load files: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting files: $e');
      return [];
    }
  }

  // Lấy danh sách file với OAuth (cho private folders)
  static Future<List<DriveFile>> getFilesWithAuth(
    String folderUrl,
    AccessCredentials credentials,
  ) async {
    try {
      final folderId = extractFolderId(folderUrl);
      if (folderId == null) {
        throw Exception('Invalid folder URL');
      }

      final client = authenticatedClient(http.Client(), credentials);
      final driveApi = drive.DriveApi(client);

      final fileList = await driveApi.files.list(
        q: "'$folderId' in parents and trashed=false",
        $fields:
            'files(id,name,mimeType,size,modifiedTime,webViewLink,thumbnailLink)',
      );

      return fileList.files
              ?.map(
                (file) => DriveFile(
                  id: file.id ?? '',
                  name: file.name ?? 'Unknown',
                  mimeType: file.mimeType ?? '',
                  size: file.size != null ? int.parse(file.size!) : null,
                  modifiedTime: file.modifiedTime,
                  webViewLink: file.webViewLink,
                  thumbnailLink: file.thumbnailLink,
                ),
              )
              .toList() ??
          [];
    } catch (e) {
      print('Error getting files with auth: $e');
      return [];
    }
  }
}

class DriveFile {
  final String id;
  final String name;
  final String mimeType;
  final int? size;
  final DateTime? modifiedTime;
  final String? webViewLink;
  final String? thumbnailLink;

  DriveFile({
    required this.id,
    required this.name,
    required this.mimeType,
    this.size,
    this.modifiedTime,
    this.webViewLink,
    this.thumbnailLink,
  });

  factory DriveFile.fromJson(Map<String, dynamic> json) {
    return DriveFile(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      mimeType: json['mimeType'] ?? '',
      size: json['size'] != null ? int.tryParse(json['size'].toString()) : null,
      modifiedTime: json['modifiedTime'] != null
          ? DateTime.tryParse(json['modifiedTime'])
          : null,
      webViewLink: json['webViewLink'],
      thumbnailLink: json['thumbnailLink'],
    );
  }

  String get fileExtension {
    if (name.contains('.')) {
      return name.split('.').last.toUpperCase();
    }
    return mimeType.split('/').last.toUpperCase();
  }

  String get formattedSize {
    if (size == null) return 'Unknown';
    if (size! < 1024) return '$size B';
    if (size! < 1024 * 1024) return '${(size! / 1024).toStringAsFixed(1)} KB';
    if (size! < 1024 * 1024 * 1024) {
      return '${(size! / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(size! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  IconData get icon {
    if (mimeType.contains('image')) return Icons.image;
    if (mimeType.contains('video')) return Icons.videocam;
    if (mimeType.contains('audio')) return Icons.audiotrack;
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
    if (mimeType.contains('document') || mimeType.contains('word')) {
      return Icons.description;
    }
    if (mimeType.contains('spreadsheet') || mimeType.contains('excel')) {
      return Icons.grid_on;
    }
    if (mimeType.contains('presentation') || mimeType.contains('powerpoint')) {
      return Icons.slideshow;
    }
    if (mimeType.contains('folder')) return Icons.folder;
    return Icons.insert_drive_file;
  }

  Color get iconColor {
    if (mimeType.contains('image')) return Colors.blue;
    if (mimeType.contains('video')) return Colors.red;
    if (mimeType.contains('audio')) return Colors.purple;
    if (mimeType.contains('pdf')) return Colors.red;
    if (mimeType.contains('document')) return Colors.blue;
    if (mimeType.contains('spreadsheet')) return Colors.green;
    if (mimeType.contains('presentation')) return Colors.orange;
    return Colors.grey;
  }
}
