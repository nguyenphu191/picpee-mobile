import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/notification_model.dart';
import 'package:picpee_mobile/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNotifications();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    final _notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    final success = await _notificationProvider.fetchNotifications();
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load notifications'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> markAllAsRead() async {
    final _notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    final success = await _notificationProvider.markAllAsRead();
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mark all as read'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final _notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    final success = await _notificationProvider.markAsRead(notificationId);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mark as read'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notiProvider, child) {
        List<NotificationModel> notifications = notiProvider.notifications;
        int unreadCount = notiProvider.unReadCount;

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
                      'Mark all',
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
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.h,
              ),
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Unread ($unreadCount)'),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => fetchNotifications(),
            child: Stack(
              children: [
                TabBarView(
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
                if (notiProvider.isLoading)
                  Container(color: Colors.black.withOpacity(0.3)),
                if (notiProvider.isLoading)
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10.r,
                            offset: Offset(0, 5.h),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.buttonGreen,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notificationList) {
    return notificationList.isEmpty
        ? Center(
            child: Text(
              "No notifications",
              style: TextStyle(fontSize: 16.h, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: notificationList.length,
            itemBuilder: (context, index) {
              final notification = notificationList[index];
              return NotificationItem(
                notification: notification,
                onTap: () {
                  if (!notification.isRead) {
                    markAsRead(notification.id);
                  }
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
              backgroundImage: NetworkImage(notification.sender.avatar.trim()),
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
                    notification.text,
                    style: TextStyle(
                      fontSize: 13.h,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    timeago.format(notification.createdTime).substring(6),
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
