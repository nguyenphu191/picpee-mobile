import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/screens/order/order_screen.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderScreen()),
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
                        order.status.displayName,
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
                Image.asset(
                  order.getServiceImg(),
                  width: 32.h,
                  height: 32.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    order.serviceName,
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'ID Order: ',
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${order.id}',
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'Submitted: ${_formatDate(order.submitted)}',
              style: TextStyle(
                fontSize: 14.h,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Due date: ${_formatDate(order.dueDate)}',
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
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.buttonGreen,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: order.designerAvatar != ""
                      ? Image.network(order.designerAvatar, fit: BoxFit.cover)
                      : Text(
                          'N',
                          style: TextStyle(
                            fontSize: 12.h,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
                SizedBox(width: 12.w),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.image, size: 18.h, color: Colors.grey[500]),
                        SizedBox(width: 4.w),
                        Text(
                          order.amount.toString(),
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        Icon(Icons.chat, size: 18.h, color: Colors.grey[500]),
                        SizedBox(width: 4.w),
                        Text(
                          "0",
                          style: TextStyle(
                            fontSize: 14.h,
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
                          size: 18.h,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          order.total.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 14.h,
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
