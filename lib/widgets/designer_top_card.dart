import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DesignerTopCardCard extends StatelessWidget {
  const DesignerTopCardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + navigation arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured Project",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _circleButton(Icons.arrow_back_ios_new, () {
                    // TODO: handle previous
                  }),
                  SizedBox(width: 8.w),
                  _circleButton(Icons.arrow_forward_ios, () {
                    // TODO: handle next
                  }),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Card with project preview
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/featured_project.jpg", // thay bằng ảnh thật
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
                Positioned(top: 12.h, left: 12.w, child: _label("Before")),
                Positioned(top: 12.h, right: 12.w, child: _label("After")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18.sp, color: Colors.black87),
      ),
    );
  }

  Widget _label(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
