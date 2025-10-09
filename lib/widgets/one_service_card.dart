import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/skill_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';

class OneServiceCard extends StatelessWidget {
  final TopDesigner designer;
  final VoidCallback? onTap;
  final bool isDuck;

  const OneServiceCard({
    super.key,
    required this.designer,
    this.onTap,
    this.isDuck = false,
  });

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
              color: !this.isDuck
                  ? Colors.black.withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
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
                  designer.imageCover,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: SizedBox(
                          width: 35.w,
                          height: 35.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey[600]!,
                            ),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
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
                    padding: EdgeInsets.only(
                      top: 20.h,
                      left: 16.h,
                      right: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: !this.isDuck ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: !this.isDuck ? Colors.white : Colors.black,
                          width: 1.h,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 65.h,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Row(
                            children: [
                              Container(
                                height: 45.h,
                                width: 45.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Loading indicator background
                                    Container(
                                      width: 45.h,
                                      height: 45.h,
                                      decoration: BoxDecoration(
                                        color: !this.isDuck
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 18.w,
                                          height: 18.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  !this.isDuck
                                                      ? Colors.white54
                                                      : Colors.grey[600]!,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Actual avatar
                                    if (designer.avatar.isNotEmpty)
                                      ClipOval(
                                        child: Image.network(
                                          designer.avatar,
                                          width: 45.h,
                                          height: 45.h,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child; // Image loaded
                                                }
                                                return Container(
                                                  width: 45.h,
                                                  height: 45.h,
                                                  color: Colors.transparent,
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 45.h,
                                                  height: 45.h,
                                                  decoration: BoxDecoration(
                                                    color: !this.isDuck
                                                        ? Colors.grey[700]
                                                        : Colors.grey[300],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: !this.isDuck
                                                        ? Colors.white
                                                        : Colors.black,
                                                    size: 18,
                                                  ),
                                                );
                                              },
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 45.h,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: !this.isDuck
                                              ? Colors.grey[700]
                                              : Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: !this.isDuck
                                              ? Colors.white
                                              : Colors.black,
                                          size: 18,
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            designer.businessName,
                                            style: TextStyle(
                                              color: !this.isDuck
                                                  ? Colors.white
                                                  : Colors.black,
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

                                    SizedBox(height: 4.w),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16.h,
                                            ),
                                            Text(
                                              '${designer.ratingPoint}',
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 14.h,
                                              ),
                                            ),
                                            Text(
                                              ' (${designer.totalReview})',
                                              style: TextStyle(
                                                color: !this.isDuck
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: designer.getStatusColor(),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                designer.getStatusIcon().icon,
                                                color: !this.isDuck
                                                    ? designer.getStatusColor()
                                                    : AppColors.textGreen,
                                                size: 14.h,
                                              ),
                                              SizedBox(width: 3.h),
                                              Text(
                                                designer
                                                    .getStatusReceiveOrder(),
                                                style: TextStyle(
                                                  color: !this.isDuck
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 12.h,
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
                                      color: !this.isDuck
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14.h,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "${designer.turnaroundTime} hours",
                                    style: TextStyle(
                                      color: !this.isDuck
                                          ? Colors.white
                                          : Colors.black,
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
                              color: !this.isDuck ? Colors.white : Colors.black,
                            ),

                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Starting at',
                                    style: TextStyle(
                                      color: !this.isDuck
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14.h,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    designer.cost.toString(),
                                    style: TextStyle(
                                      color: !this.isDuck
                                          ? Colors.white
                                          : Colors.black,
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
