import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirmDelete;

  const DeleteAccountDialog({
    Key? key,
    required this.onConfirmDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        'Delete Account',
        style: TextStyle(
          fontSize: 18.h,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: Text(
        'Are you sure you want to delete your account? This action cannot be undone.',
        style: TextStyle(fontSize: 14.h),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmDelete();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static void show({
    required BuildContext context,
    required VoidCallback onConfirmDelete,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialog(onConfirmDelete: onConfirmDelete);
      },
    );
  }
}