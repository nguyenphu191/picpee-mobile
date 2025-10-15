import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/notification_model.dart';
import 'package:picpee_mobile/services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  bool _isloading = false;
  int _unreadCount = 0;
  List<NotificationModel> _notifications = [];

  bool get isLoading => _isloading;
  int get unReadCount => _unreadCount;
  List<NotificationModel> get notifications => _notifications;

  void setLoading() {
    _isloading = !_isloading;
    notifyListeners();
  }

  // Lấy danh sách thông báo
  Future<bool> fetchNotifications() async {
    setLoading();
    try {
      final (fetchedNotifications, fetchedUnreadCount) =
          await _notificationService.fetchNotifications();
      _notifications = fetchedNotifications;
      _unreadCount = fetchedUnreadCount;

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      setLoading();
    }
    return false;
  }

  // Đánh dấu tất cả thông báo là đã đọc
  Future<bool> markAllAsRead() async {
    setLoading();
    try {
      final success = await _notificationService.markAllAsRead();
      if (success) {
        _unreadCount = 0;
        for (NotificationModel notification in _notifications) {
          notification.isRead = true;
        }
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Error marking all as read: $e");
    } finally {
      setLoading();
    }
    return false;
  }

  // Đánh dấu một thông báo là đã đọc
  Future<bool> markAsRead(int notificationId) async {
    setLoading();
    try {
      final success = await _notificationService.markAsRead(notificationId);
      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1 && !_notifications[index].isRead) {
          _notifications[index].isRead = true;
          _unreadCount = (_unreadCount > 0) ? _unreadCount - 1 : 0;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      debugPrint("Error marking as read: $e");
    } finally {
      setLoading();
    }
    return false;
  }

  //lấy số lượng thông báo chưa đọc
  Future<bool> fetchUnreadCount() async {
    setLoading();
    try {
      final count = await _notificationService.countUnread();
      _unreadCount = count;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error fetching unread count: $e");
    } finally {
      setLoading();
    }
    return false;
  }
}
