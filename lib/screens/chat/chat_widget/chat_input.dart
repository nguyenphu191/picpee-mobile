import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({
    Key? key,
    required this.messageController,
    required this.onSendMessage,
    required this.onPickImage,
  }) : super(key: key);

  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.black54, size: 24.h),
            onPressed: onPickImage,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: messageController,
              maxLines: null, // Cho phép nhiều dòng
              minLines: 1, // Tối thiểu 1 dòng
              keyboardType: TextInputType.multiline, // Cho phép nhập nhiều dòng
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true, // Giúp giảm padding mặc định
              ),
              onSubmitted: (_) => onSendMessage(),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: onSendMessage,
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              AppImages.SendIcon,
              width: 28.h,
              height: 28.h,
              fit: BoxFit.cover,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
