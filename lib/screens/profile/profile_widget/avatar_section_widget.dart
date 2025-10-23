import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:picpee_mobile/core/theme/app_colors.dart';

class AvatarSectionWidget extends StatelessWidget {
  final File? avatarImage;
  final String avatar;
  final VoidCallback onImagePickerTap;
  final String name;

  const AvatarSectionWidget({
    Key? key,
    required this.avatar,
    required this.avatarImage,
    required this.onImagePickerTap,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avatar',
          style: TextStyle(
            fontSize: 14.h,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),

        Row(
          children: [
            // Avatar
            Container(
              height: 80.h,
              width: 80.h,
              decoration: BoxDecoration(
                color: (avatarImage == null && avatar == "")
                    ? AppColors.buttonGreen
                    : null,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: avatarImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        avatarImage!,
                        fit: BoxFit.cover,
                        width: 80.h,
                        height: 80.h,
                      ),
                    )
                  : avatar != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        avatar.trim(),
                        fit: BoxFit.cover,
                        width: 80.h,
                        height: 80.h,
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
                      ),
                    )
                  : Center(
                      child: Text(
                        name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),

            SizedBox(width: 20.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onImagePickerTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upload,
                            size: 16.h,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Upload new image',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'At least 800x800 px recommended.\nJPG or PNG is allowed',
                    style: TextStyle(fontSize: 11.h, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
