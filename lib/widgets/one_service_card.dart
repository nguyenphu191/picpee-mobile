import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';

class OneServiceCard extends StatelessWidget {
  final ServiceData service;
  final VoidCallback? onTap;

  const OneServiceCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 370.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                height: 240.h,
                width: double.infinity,
                child: Image.network(
                  service.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 210.h,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: TopNotchClipper(),
                  child: Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      border: Border(
                        top: BorderSide(color: Colors.white, width: 1.h),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(16, 28.h, 16, 16),
                    child: Column(
                      children: [
                        Container(
                          height: 58.h,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Row(
                            children: [
                              Container(
                                height: 50.h,
                                width: 50.h,
                                decoration: BoxDecoration(
                                  color: AppColors.buttonGreen,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    service.editorAvatar,
                                  ),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {},
                                  child: service.editorAvatar.isEmpty
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : null,
                                ),
                              ),

                              SizedBox(width: 12.h),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            service.editorName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.h,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 16.h),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            '+',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 4.h),

                                    // Rating and auto-accepting
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16.h,
                                        ),
                                        SizedBox(width: 4.h),
                                        Text(
                                          '${service.rating} (${service.reviewCount})',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.h,
                                          ),
                                        ),
                                        if (service.isAutoAccepting) ...[
                                          SizedBox(width: 32.h),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: AppColors.brandGreen,
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                                SizedBox(width: 3.h),
                                                Text(
                                                  'Auto-accepting',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.h,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Turnaround time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.h,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    service.turnaroundTime,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 30.h,
                              width: 1,
                              color: Colors.white,
                            ),

                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Starting at',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.h,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    service.startingPrice,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceData {
  final String title;
  final String imageUrl;
  final String editorName;
  final String editorAvatar;
  final double rating;
  final int reviewCount;
  final String turnaroundTime;
  final String startingPrice;
  final bool isAutoAccepting;

  ServiceData({
    required this.title,
    required this.imageUrl,
    required this.editorName,
    required this.editorAvatar,
    required this.rating,
    required this.reviewCount,
    required this.turnaroundTime,
    required this.startingPrice,
    this.isAutoAccepting = false,
  });
}

// TopNotchClipper để tạo hiệu ứng lõm giữa
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
