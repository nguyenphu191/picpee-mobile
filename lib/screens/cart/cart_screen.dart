import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/core/utils/mock_order_data.dart';
import 'package:picpee_mobile/models/order_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Order> cartItems = MockOrderData.getAllOrders();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.h,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return _buildItemCard(item);
          },
        ),
      ),
    );
  }

  _buildItemCard(Order item) {
    return Container(
      height: 168.h,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'HDR${item.id}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$${item.total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    item.getServiceImg(),
                    width: 30.h,
                    height: 30.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    item.serviceName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.h,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              Text(
                'Qty: ${item.amount.round()}',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey, width: 1.2),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    "https://tse2.mm.bing.net/th/id/OIP.gRsMK8djOPccYsCUVi2fYAHaDt?pid=Api&h=220&P=0",
                    width: 30.h,
                    height: 30.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  item.designerName,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          //Checkout button / Delete button
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle checkout action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () {
                  // Handle delete action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
