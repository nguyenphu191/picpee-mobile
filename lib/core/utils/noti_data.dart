import 'package:picpee_mobile/models/notification_model.dart';

final List<NotificationModel> notificationsData = [
  NotificationModel(
    id: '1',
    senderName: 'J.M.Designs',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    title: 'Your order status has been updated.',
    message: 'J.M.Designs has processed your modification request. Please check the order and confirm within 3 days. If it takes more than 3 days, the order will be automatically approved and completed.',
    timestamp: DateTime.now().subtract(Duration(days: 14)),
    isRead: false,
  ),
  NotificationModel(
    id: '2',
    senderName: 'J.M.Designs',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    title: 'Your order status has been updated.',
    message: 'J.M.Designs has processed your modification request. Please check the order and confirm within 3 days. If it takes more than 3 days, the order will be automatically approved and completed.',
    timestamp: DateTime.now().subtract(Duration(days: 2)),
    isRead: false,
  ),
  NotificationModel(
    id: '3',
    senderName: 'J.M.Designs',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    title: 'Your order status has been updated.',
    message: 'J.M.Designs has processed your modification request. Please check the order and confirm within 3 days. If it takes more than 3 days, the order will be automatically approved and completed.',
    timestamp: DateTime.now().subtract(Duration(days: 10)),
    isRead: false,
  ),
  NotificationModel(
    id: '4',
    senderName: 'PhotoFixPro',
    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    title: 'Discount offer available!',
    message: 'Get 15% off on your next order with PhotoFixPro. Limited time offer!',
    timestamp: DateTime.now().subtract(Duration(days: 3)),
    isRead: true,
  ),
  NotificationModel(
    id: '5',
    senderName: 'System',
    avatarUrl: 'https://ui-avatars.com/api/?name=Picpee&background=0D8ABC&color=fff',
    title: 'Welcome to Picpee!',
    message: 'Thanks for joining Picpee. Start exploring our services and connect with professional designers.',
    timestamp: DateTime.now().subtract(Duration(days: 30)),
    isRead: true,
  ),
];