import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:picpee_mobile/screens/order/order_widget/purchase_order_card.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrders();
    });
  }

  Future<void> fetchOrders() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final succes = await orderProvider.fetchOrdersByStaus("PENDING_ORDER");
    if (!succes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load orders'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteOrder(int orderId) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.deleteOrder(orderId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final cartItems = orderProvider.orders;
        return Stack(
          children: [
            Scaffold(
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
              body: cartItems.isEmpty
                  ? Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return _buildItemCard(item);
                        },
                      ),
                    ),
            ),
            if (orderProvider.loading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.buttonGreen,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  _buildItemCard(OrderModel item) {
    return Container(
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
                  item.projectName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$${_formatPrice(item.cost)}',
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
                  Image.network(
                    item.skill!.urlImage.trim(),
                    width: 30.h,
                    height: 30.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 20.h,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.buttonGreen,
                            ),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.broken_image,
                        size: 30.h,
                        color: Colors.grey,
                      );
                    },
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    item.skill!.name,
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
                'Qty: ${item.quantity.round()}',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          //Checkout button / Delete button
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipOval(
                child: Image.network(
                  item.vendor?.avatar ?? '',
                  width: 30.h,
                  height: 30.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: 20.h,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.buttonGreen,
                          ),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.account_circle,
                      size: 30.h,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => PurchaseOrderCard(order: item),
                  );
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: Text(
                        'Are you sure you want to delete this order from your cart?',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.h,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteOrder(item.id);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red, fontSize: 14.h),
                          ),
                        ),
                      ],
                    ),
                  );
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
