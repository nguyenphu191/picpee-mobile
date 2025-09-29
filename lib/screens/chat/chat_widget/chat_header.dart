import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    Key? key,
    required this.userName,
    required this.onClose,
    required this.onImageGalleryOpen,
    required this.avatar,
  }) : super(key: key);

  final String userName;
  final VoidCallback onClose;
  final VoidCallback onImageGalleryOpen;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black54, size: 24.h),
            onPressed: onClose,
          ),
          this.avatar == ""
              ? CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  radius: 20.h,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '',
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(this.avatar),
                  radius: 22.h,
                ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.h,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12.h,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onImageGalleryOpen,
            child: Image.asset(
              AppImages.OpenFileIcon,
              width: 28.h,
              height: 28.h,
              fit: BoxFit.cover,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
