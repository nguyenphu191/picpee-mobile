import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/screens/cart/cart_screen.dart';
import 'package:picpee_mobile/screens/favorite/favorite_screen.dart';
import 'package:picpee_mobile/screens/home/home_screen.dart';
import 'package:picpee_mobile/screens/notification/notification_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, AppColors.textGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(35.r),
        border: Border.all(color: Colors.white12),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Image.asset(AppImages.logo1, height: 40.sp),
          ),
          SizedBox(width: 8.w),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
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
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 24.h,
                      ),
                    ),
                  ),
                  Positioned(
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
                  ),
                ],
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
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      },
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 24.h,
                      ),
                    ),
                  ),
                  Positioned(
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
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Icon(Icons.menu, color: Colors.white, size: 24.h),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
