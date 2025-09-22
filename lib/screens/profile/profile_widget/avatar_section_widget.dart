import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

class AvatarSectionWidget extends StatelessWidget {
  final File? avatarImage;
  final String avatarInitial;
  final VoidCallback onImagePickerTap;

  const AvatarSectionWidget({
    Key? key,
    required this.avatarImage,
    required this.avatarInitial,
    required this.onImagePickerTap,
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
                color: avatarImage == null ? Colors.lightGreen : null,
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
                  : Center(
                      child: Text(
                        avatarInitial,
                        style: TextStyle(
                          color: Colors.white,
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
