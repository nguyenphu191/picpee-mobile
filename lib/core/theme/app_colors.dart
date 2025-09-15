import 'package:flutter/material.dart';

/// Centralized color system for Picpee-style UI
class AppColors {
  // Base colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color buttonGreen = Color(0xFF4AF73E);
  // Backgrounds
  static const Color backgroundDark = Color(0xFF0F1115); // nền đen/xám đậm
  static const Color backgroundLight = Color(0xFFF5F5F7); // cho section sáng
  static const Color cardDark = Color(0xFF1C1F24); // thẻ / sidebar

  // Text

  static const Color textPrimary = Colors.white;
  static const Color textGreen = Color(0xFF022C28);
  static const Color textSecondary = Color(0xFFB0B3B8); // chữ xám phụ
  static const Color linkBlue = Color(0xFF011AFF); // link và nút bấm
  static const Color textHighlight = Color(
    0xFF00FF66,
  ); // highlight xanh lá neon

  // Brand colors
  static const Color brandGreen = Color(0xFF00FF66); // xanh neon
  static const Color brandPurple = Color(0xFF9C6ADE); // tím pastel
  static const Color brandRed = Color(0xFFFF4C4C); // đỏ cảnh báo
  static const Color brandDuckGreen = Color.fromARGB(255, 2, 36, 13);
  static const Color brandDuck = Color.fromARGB(255, 0, 12, 4);
  // Status
  static const Color success = Color(0xFF00C853); // xanh lá đậm hơn
  static const Color warning = Color(0xFFFFB300); // vàng cảnh báo
  static const Color error = Color(0xFFD32F2F); // đỏ lỗi
  static const Color info = Color(0xFF29B6F6); // xanh dương nhạt

  // Borders
  static const Color borderDark = Color(0xFF2C2F36);
  static const Color borderLight = Color(0xFFE0E0E0);

  // Gradient (banner / button style)
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF00FF66), Color(0xFF9C6ADE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFFC1E8DA), Color(0xFF4CF740)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
