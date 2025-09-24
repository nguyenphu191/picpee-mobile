class NotificationModel {
  final String id;
  final String senderName;
  final String avatarUrl;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.senderName,
    required this.avatarUrl,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}
