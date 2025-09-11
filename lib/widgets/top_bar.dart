import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 80.h,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, AppColors.textGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu, color: AppColors.textGreen, size: 30.sp),
            Text(
              'Picpee',
              style: TextStyle(
                color: AppColors.textGreen,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.account_circle, color: AppColors.textGreen, size: 30.sp),
          ],
        ),
      ),
    );
  }
}
