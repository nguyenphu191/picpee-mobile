import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/providers/discount_provider.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:provider/provider.dart';

class PurchaseOrderCard extends StatefulWidget {
  const PurchaseOrderCard({super.key, required this.order});
  final OrderModel order;
  @override
  State<PurchaseOrderCard> createState() => _PurchaseOrderCardState();
}

class _PurchaseOrderCardState extends State<PurchaseOrderCard> {
  final TextEditingController _nameController = TextEditingController();
  double _discountAmount = 0;
  double _taxAmount = 0;
  String _type = "%";

  @override
  void initState() {
    super.initState();
    _calculateTax();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _calculateTax() {
    _taxAmount = widget.order.cost * 0.1;
  }

  double get _subtotal => widget.order.cost;
  double get _total => (_subtotal + _taxAmount - _discountAmount) > 0
      ? (_subtotal + _taxAmount - _discountAmount)
      : 0;
  double get _currentBalance => 729.02;
  double get _balanceAfterPurchase => _currentBalance - _total;

  Future<void> _handleSubmit() async {}

  Future<void> _applyPromotionCode(String code, int vendorId) async {
    final discountProvider = Provider.of<DiscountProvider>(
      context,
      listen: false,
    );
    final success = await discountProvider.fetchDiscountByCode(code, vendorId);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid promotion code'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _discountAmount = discountProvider.appliedDiscount!.discountValue;
        discountProvider.appliedDiscount!.discountType == 'PERCENTAGE'
            ? _type = '%'
            : _type = '\$';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.9;
    final contentHeight = 538.h;

    return Consumer2<DiscountProvider, OrderProvider>(
      builder: (context, discountProvider, orderProvider, _) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 660.h,
            width: cardWidth,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80.h,
                    width: cardWidth,
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.background3),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      border: Border.all(
                        color: const Color.fromARGB(255, 11, 121, 14),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16.w,
                          top: 20.h,
                          child: Text(
                            'Purchase Order',
                            style: TextStyle(
                              fontSize: 14.h,
                              fontWeight: FontWeight.bold,
                              color: AppColors.buttonGreen,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20.h,
                          right: 16.w,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 24.h,
                              height: 24.h,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 20.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 60.h,
                  left: 0.w,
                  right: 0.w,
                  child: ClipPath(
                    clipper: TopNotchClipper(),
                    child: Container(
                      width: cardWidth,
                      height: contentHeight,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  widget.order.skill!.urlImage.trim(),
                                  width: 30.h,
                                  height: 30.h,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: SizedBox(
                                            width: 20.h,
                                            height: 20.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    AppColors.buttonGreen,
                                                  ),
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
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
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    widget.order.skill!.name,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${_formatPrice(widget.order.cost)}',
                                  style: TextStyle(
                                    fontSize: 16.h,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  'Editor: ',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                ClipOval(
                                  child: Image.network(
                                    widget.order.vendor!.avatar!.trim(),
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  AppColors.buttonGreen,
                                                ),
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
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
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Promotion Code',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _nameController,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Please enter a promotion code';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Input your promotion code',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.h,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 8.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    InkWell(
                                      onTap: () {
                                        if (_nameController.text.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please enter a promotion code',
                                              ),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } else {
                                          _applyPromotionCode(
                                            _nameController.text.trim(),
                                            widget.order.vendor!.id,
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.buttonGreen,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (_discountAmount > 0) ...[
                              SizedBox(height: 8.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'You get $_type$_discountAmount off',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 16.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Summary',
                                    style: TextStyle(
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildSummaryRow(
                                    'Subtotal',
                                    '\$${_formatPrice(_subtotal)}',
                                  ),
                                  SizedBox(height: 8.h),
                                  _buildSummaryRow(
                                    'Tax Amount',
                                    '\$${_formatPrice(_taxAmount)}',
                                  ),
                                  SizedBox(height: 8.h),
                                  _buildSummaryRow(
                                    'Discount',
                                    '\$${_formatPrice(_discountAmount)}',
                                  ),
                                  Divider(
                                    height: 16.h,
                                    color: Colors.grey[300],
                                  ),
                                  _buildSummaryRow(
                                    'Total',
                                    '\$${_formatPrice(_total)}',
                                    isBold: true,
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildSummaryRow(
                                    'Current Balance',
                                    '\$${_formatPrice(_currentBalance)}',
                                  ),
                                  SizedBox(height: 8.h),
                                  _buildSummaryRow(
                                    'After purchase',
                                    '\$${_formatPrice(_balanceAfterPurchase)}',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            InkWell(
                              onTap:
                                  (discountProvider.isLoading ||
                                      orderProvider.loading)
                                  ? null
                                  : _handleSubmit,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (discountProvider.isLoading ||
                                          orderProvider.loading)
                                      ? AppColors.buttonGreen.withOpacity(0.6)
                                      : AppColors.buttonGreen,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                                child:
                                    (discountProvider.isLoading ||
                                        orderProvider.loading)
                                    ? Center(
                                        child: SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                        ),
                                      )
                                    : Text(
                                        'Submit Order',
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.h,
            color: Colors.grey[600],
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.h,
            color: Colors.black,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
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
}
