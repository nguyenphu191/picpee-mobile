import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/screens/order/order_screen.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;
  String _formatPrice(double price) {
    if (price == price.toInt()) {
      return price.toInt().toString();
    }
    String fixed = price.toStringAsFixed(2);
    if (fixed.endsWith('0')) {
      return price.toStringAsFixed(1);
    }
    return fixed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderScreen(order: order)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: order.getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        order.getStatusIcon(),
                        color: order.getStatusColor(),
                        size: 18.h,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        order.getStatusText(),
                        style: TextStyle(
                          color: order.getStatusColor(),
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Image.network(
                  order.skill!.urlImage.trim(),
                  height: 28.h,
                  width: 28.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 28.h,
                      width: 28.h,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: Icon(Icons.broken_image, size: 16.h),
                    );
                  },
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    order.skill!.name,
                    style: TextStyle(
                      fontSize: 18.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Row(
            //   children: [
            //     Text(
            //       'ID Order: ',
            //       style: TextStyle(
            //         fontSize: 14.h,
            //         color: Colors.grey[600],
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //     Text(
            //       '${order.id}',
            //       style: TextStyle(
            //         fontSize: 14.h,
            //         color: Colors.black,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 4.h),
            Text(
              'Submitted: ${order.createdTime}',
              style: TextStyle(
                fontSize: 14.h,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Due date: ${order.dueTime}',
              style: TextStyle(
                fontSize: 14.h,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 28.h,
                  width: 28.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.buttonGreen,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      order.vendor!.avatar?.trim() ??
                          'https://placeholder.com/avatar.png',
                      height: 28.h,
                      width: 28.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            order.vendor!.businessName!.isNotEmpty
                                ? order.vendor!.businessName![0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.h,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.image, size: 20.h, color: Colors.red),
                        SizedBox(width: 4.w),
                        Text(
                          order.quantity.toString(),
                          style: TextStyle(
                            fontSize: 16.h,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        Icon(Icons.chat, size: 20.h, color: Colors.blue),
                        SizedBox(width: 4.w),
                        Text(
                          order.countComments.toString(),
                          style: TextStyle(
                            fontSize: 16.h,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 20.h,
                          color: Colors.orange,
                        ),
                        Text(
                          _formatPrice(order.cost),
                          style: TextStyle(
                            fontSize: 16.h,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
