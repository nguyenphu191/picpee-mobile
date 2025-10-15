import 'package:intl/intl.dart';

class ProjectModel {
  int id;
  String name;
  String status;
  String moveTrashTime;
  String deletedTime;
  String createdTime;
  String modifiedTime;
  String lastOrderTime;
  String skillNames;

  ProjectModel({
    required this.id,
    required this.name,
    required this.status,
    required this.moveTrashTime,
    required this.deletedTime,
    required this.createdTime,
    required this.modifiedTime,
    required this.lastOrderTime,
    required this.skillNames,
  });

  /// Tạo object từ JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      moveTrashTime: _timestampToDate(json['moveTrashTime']),
      deletedTime: _timestampToDate(json['deletedTime']),
      createdTime: _timestampToDate(json['createdTime']),
      modifiedTime: _timestampToDate(json['modifiedTime']),
      lastOrderTime: _timestampToDate(json['lastOrderTime']),
      skillNames: json['skillNames'] ?? '',
    );
  }

  /// Chuyển timestamp UTC -> giờ local của thiết bị và format
  static String _timestampToDate(dynamic value) {
    if (value == null || value == 0) {
      return "";
    }
    // Convert từ UTC sang giờ local
    final utcDate = DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    final localDate = utcDate.toLocal();

    return DateFormat('dd/MM/yyyy hh:mm a').format(localDate);
  }

  /// Chuyển chuỗi timestamp sang DateTime (UTC)
  static DateTime timestampStringToDateTime(String timestamp) {
    final int value = int.tryParse(timestamp) ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }

  /// Chuyển DateTime sang chuỗi số timestamp UTC
  static String dateTimeToTimestampString(DateTime date) {
    return date.toUtc().millisecondsSinceEpoch.toString();
  }

  /// Format DateTime thành dạng "03:31 PM" (local)
  static String formatDateTimeAMPM(DateTime date) {
    return DateFormat('hh:mm a').format(date.toLocal());
  }

  /// Convert object sang JSON (nếu cần gửi ngược lên server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'moveTrashTime': moveTrashTime,
      'deletedTime': deletedTime,
      'createdTime': createdTime,
      'modifiedTime': modifiedTime,
      'lastOrderTime': lastOrderTime,
      'skillNames': skillNames,
    };
  }
}
