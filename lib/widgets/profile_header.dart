import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/screens/cart/cart_screen.dart';
import 'package:picpee_mobile/screens/favorite/favorite_screen.dart';
import 'package:picpee_mobile/screens/notification/notification_screen.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, this.title = 'Account'});
  final String title;
  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
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
                  image: DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/300?img=5'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
