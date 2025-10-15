import 'package:intl/intl.dart';

class OrderActivityModel {
  int id;
  String title;
  String content;
  int rating;
  String createdTime;
  String role;
  String type;

  OrderActivityModel({
    required this.id,
    required this.title,
    required this.content,
    required this.rating,
    required this.createdTime,
    required this.role,
    required this.type,
  });

  factory OrderActivityModel.fromJson(Map<String, dynamic> json) {
    return OrderActivityModel(
      id: json['orderId'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      rating: json['rating'] ?? 0,
      createdTime: _timestampToDate(json['createdTime']),
      role: json['creator'] != null ? (json['creator']['role'] ?? '') : '',
      type: json['type'] ?? '',
    );
  }

  /// Chuyển timestamp UTC -> giờ local của thiết bị và format
  static String _timestampToDate(dynamic value) {
    if (value == null || value == 0) return "";
    final utcDate = DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    final localDate = utcDate.toLocal();
    return DateFormat('dd/MM/yyyy hh:mm a').format(localDate);
  }
}
