import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopNotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    double notchWidth = 120.w; // Notch width
    double notchDepth = 8.w; // Notch depth

    // Start from top-left corner
    path.lineTo((size.width - notchWidth) / 2, 0);
    // Create trapezoid notch
    path.lineTo(size.width / 2 - notchWidth / 3, notchDepth);
    path.lineTo(size.width / 2 + notchWidth / 3, notchDepth);
    path.lineTo((size.width + notchWidth) / 2, 0);
    // Continue with the rest of the edges
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
