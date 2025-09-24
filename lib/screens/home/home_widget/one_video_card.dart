import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/service_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';

class OneVideoCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;

  const OneVideoCard({super.key, required this.service, this.onTap});

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
          child: Column(
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 12.h, left: 16.h, right: 16.h),
                  decoration: BoxDecoration(color: Colors.green[50]),
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  service.designer.avatarUrl,
                                ),
                                onBackgroundImageError:
                                    (exception, stackTrace) {},
                                child: service.designer.avatarUrl.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        color: Colors.black,
                                        size: 18,
                                      )
                                    : null,
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
                                          service.designer.name,
                                          style: TextStyle(
                                            color: Colors.black,
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
                                            '${service.rating}',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 14.h,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            ' (${service.reviewCount})',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "\$ ${service.startingPrice.toString()}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
