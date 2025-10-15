import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/notification_model.dart';
import 'package:picpee_mobile/services/auth_service.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;

class NotificationService {
  // Lấy danh sách thông báo
  Future<(List<NotificationModel>, int)> fetchNotifications() async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }
    final response = await http.post(
      Uri.parse(Url.getListNotifications),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      int unreadCount = data['countUnread'] ?? 0;
      List<NotificationModel> notifications = (data['list'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList();
      return (notifications, unreadCount);
    } else {
      throw Exception("Failed to load notifications");
    }
  }

  // Đánh dấu tất cả thông báo là đã đọc
  Future<bool> markAllAsRead() async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }
    final response = await http.post(
      Uri.parse(Url.markAllNotificationsAsRead),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Đánh dấu một thông báo là đã đọc
  Future<bool> markAsRead(int notificationId) async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }
    final response = await http.post(
      Uri.parse(Url.markNotificationAsRead),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"id": notificationId}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Đếm số thông báo chưa đọc
  Future<int> countUnread() async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }
    final response = await http.post(
      Uri.parse(Url.getCountUnreadNotifications),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      return res['data']['count'] ?? 0;
    } else {
      throw Exception("Failed to count unread notifications");
    }
  }
}
