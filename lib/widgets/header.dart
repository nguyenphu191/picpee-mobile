import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.r),
        border: Border.all(color: Colors.white24),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Logo
          Image.asset(AppImages.logo1, height: 40.sp),
          SizedBox(width: 8.w),

          /// Icon bên phải
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 24.h,
                ),
              ),
              SizedBox(width: 5.w),

              /// Notification + chấm đỏ
              Stack(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.h,
                    child: InkWell(
                      onTap: () {},
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

              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 24.h,
                ),
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
