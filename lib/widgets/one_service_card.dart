import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/service_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';

class OneServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final bool isDuck;

  const OneServiceCard({
    super.key,
    required this.service,
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
                  service.afterImageUrl,
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
                                height: 50.h,
                                width: 50.h,
                                decoration: BoxDecoration(
                                  color: AppColors.buttonGreen,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    service.designer != null
                                        ? service.designer!.avatarUrl
                                        : '',
                                  ),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {},
                                  child: service.designer!.avatarUrl.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          color: !this.isDuck
                                              ? Colors.white
                                              : Colors.black,
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
                                            service.designer != null
                                                ? service.designer!.name
                                                : 'Unknown Designer',
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
                                          '${service.rating}',
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 14.h,
                                          ),
                                        ),
                                        Text(
                                          ' (${service.reviewCount})',
                                          style: TextStyle(
                                            color: !this.isDuck
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.h,
                                          ),
                                        ),
                                        if (service
                                            .designer!
                                            .isAutoAccepting) ...[
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
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: !this.isDuck
                                                      ? AppColors.buttonGreen
                                                      : AppColors.textGreen,
                                                  size: 14.h,
                                                ),
                                                SizedBox(width: 3.h),
                                                Text(
                                                  'Auto-accepting',
                                                  style: TextStyle(
                                                    color: !this.isDuck
                                                        ? Colors.white
                                                        : Colors.black,
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
                                      color: !this.isDuck
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14.h,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    service.turnaroundTime,
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
                                    service.startingPrice.toString(),
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
