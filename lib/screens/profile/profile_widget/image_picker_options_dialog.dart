import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerOptionsDialog extends StatelessWidget {
  final File? currentAvatarImage;
  final Function(ImageSource) onImageSourceSelected;
  final VoidCallback? onRemovePhoto;

  const ImagePickerOptionsDialog({
    Key? key,
    this.currentAvatarImage,
    required this.onImageSourceSelected,
    this.onRemovePhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Wrap(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.h),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Select Profile Picture',
                    style: TextStyle(
                      fontSize: 18.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Camera option
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.blue.shade600,
                        size: 24.h,
                      ),
                    ),
                    title: Text(
                      'Take Photo',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onImageSourceSelected(ImageSource.camera);
                    },
                  ),

                  // Gallery option
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.photo_library,
                        color: Colors.green.shade600,
                        size: 24.h,
                      ),
                    ),
                    title: Text(
                      'Choose from Gallery',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onImageSourceSelected(ImageSource.gallery);
                    },
                  ),

                  // Remove photo option (if there's an existing photo)
                  if (currentAvatarImage != null && onRemovePhoto != null) ...[
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade600,
                          size: 24.h,
                        ),
                      ),
                      title: Text(
                        'Remove Photo',
                        style: TextStyle(
                          fontSize: 16.h,
                          fontWeight: FontWeight.w500,
                          color: Colors.red.shade600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onRemovePhoto!();
                      },
                    ),
                  ],

                  SizedBox(height: 10.h),

                  // Cancel button
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.h,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show({
    required BuildContext context,
    File? currentAvatarImage,
    required Function(ImageSource) onImageSourceSelected,
    VoidCallback? onRemovePhoto,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ImagePickerOptionsDialog(
          currentAvatarImage: currentAvatarImage,
          onImageSourceSelected: onImageSourceSelected,
          onRemovePhoto: onRemovePhoto,
        );
      },
    );
  }
}