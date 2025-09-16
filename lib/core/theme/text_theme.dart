import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextTheme {
  static TextStyle roboto({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    double? height,
  }) => TextStyle(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
    fontStyle: fontStyle,
    height: height,
  );

  static TextStyle get heading1 =>
      roboto(fontSize: 24.h, fontWeight: FontWeight.w700);
  static TextStyle get heading2 =>
      roboto(fontSize: 22.h, fontWeight: FontWeight.w700);
  static TextStyle get title =>
      roboto(fontSize: 18.h, fontWeight: FontWeight.w600);
  static TextStyle get normal => roboto(fontSize: 14.h);
  static TextStyle get caption =>
      roboto(fontSize: 12.h, color: Colors.grey[600]);

  static TextStyle get button =>
      roboto(fontSize: 16.h, fontWeight: FontWeight.bold);
}
