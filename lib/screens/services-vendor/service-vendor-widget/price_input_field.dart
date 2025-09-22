import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? suffix;

  const PriceInputField({
    Key? key,
    required this.label,
    required this.controller,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.h,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!, width: 1.2),
          ),
          child: Row(
            children: [
              Text(
                '\$',
                style: TextStyle(
                  fontSize: 16.h,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontSize: 16.h, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontSize: 16.h,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              if (suffix != null)
                Text(
                  suffix!,
                  style: TextStyle(
                    fontSize: 14.h,
                    color: const Color(0xFF888888),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}