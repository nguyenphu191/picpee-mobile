import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/utils/noti_data.dart';
import 'package:picpee_mobile/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationModel> notifications = List.from(notificationsData);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.h,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: Row(
              children: [
                Text(
                  'Mark all as read',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.h),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey[600],
                  size: 16.h,
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.h),
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Unread ($unreadCount)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All notifications
          _buildNotificationList(notifications),

          // Unread notifications
          _buildNotificationList(
            notifications.where((n) => !n.isRead).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notificationList) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        final notification = notificationList[index];
        return NotificationItem(
          notification: notification,
          onTap: () {
            setState(() {
              notification.isRead = true;
            });
            // Navigate to order details or relevant screen
          },
        );
      },
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1.0),
          ),
          color: notification.isRead ? Colors.white : Colors.grey[50],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 20.h,
              backgroundImage: NetworkImage(notification.avatarUrl),
            ),
            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // Unread indicator
                      if (!notification.isRead)
                        Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13.h,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    timeago.format(notification.timestamp),
                    style: TextStyle(fontSize: 12.h, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
