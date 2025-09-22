import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordFieldWidget extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isVisible;
  final VoidCallback toggleVisibility;

  const PasswordFieldWidget({
    Key? key,
    required this.hint,
    required this.controller,
    required this.isVisible,
    required this.toggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[400],
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: toggleVisibility,
            icon: Icon(
              isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}