import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/providers/auth_provider.dart';
import 'package:picpee_mobile/providers/notification_provider.dart';
import 'package:picpee_mobile/providers/user_provider.dart';
import 'package:picpee_mobile/screens/cart/cart_screen.dart';
import 'package:picpee_mobile/screens/favorite/favorite_screen.dart';
import 'package:picpee_mobile/screens/notification/notification_screen.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, this.title = 'Account'});
  final String title;
  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotificationUnread();
    });
  }

  Future<void> _fetchNotificationUnread() async {
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    final res = await notificationProvider.fetchUnreadCount();
    if (!res) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching unread notifications"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationProvider, UserProvider>(
      builder: (context, notificationProvider, userProvider, child) {
        final unreadCount = notificationProvider.unReadCount;
        return Container(
          height: 85.h,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Icon(Icons.menu, color: Colors.black, size: 24.h),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FavoriteScreen();
                          },
                        ),
                      );
                    },
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                      size: 24.h,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Stack(
                    children: [
                      Container(
                        height: 40.h,
                        width: 40.h,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NotificationScreen();
                                },
                              ),
                            );
                          },
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                            size: 24.h,
                          ),
                        ),
                      ),
                      unreadCount > 0
                          ? Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 40.h,
                        width: 40.h,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CartScreen();
                                },
                              ),
                            );
                          },
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.black,
                            size: 24.h,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12.h,
                        top: 12.h,
                        child: Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 8.w),
                  Container(
                    height: 45.h,
                    width: 45.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.lightGreen,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        userProvider.user!.avatar?.trim() ??
                            'https://picsum.photos/200',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text("N/A"));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
