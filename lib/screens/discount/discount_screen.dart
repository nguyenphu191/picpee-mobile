import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/models/discount_model.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Demo data
  final List<DiscountModel> discounts = [
    DiscountModel(
      id: '1',
      promoCode: 'SUMMER2023',
      designerName: 'John Doe',
      type: '%',
      amount: 20,
      status: true,
      createDate: DateTime.now(),
    ),
    DiscountModel(
      id: '2',
      promoCode: 'WELCOME50',
      designerName: 'Jane Smith',
      type: "\$",
      amount: 50,
      status: false,
      createDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<DiscountModel> get filteredDiscounts {
    final query = _searchController.text.toLowerCase();
    return discounts.where((discount) {
      return discount.promoCode.toLowerCase().contains(query) ||
          discount.designerName.toLowerCase().contains(query);
    }).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: const SideBar(selectedIndex: 2),
      body: Stack(
        children: [
          Positioned(
            top: 70.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.h),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search by promo code or designer name',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: 20.h,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey[500],
                                  size: 20.h,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 16.w,
                        ),
                      ),
                    ),
                  ),

                  // Discount List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: filteredDiscounts.length,
                      itemBuilder: (context, index) {
                        final discount = filteredDiscounts[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.all(12.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          discount.promoCode,
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '${discount.amount}${discount.type}',
                                          style: TextStyle(
                                            fontSize: 12.h,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Designer: ${discount.designerName}',
                                          style: TextStyle(
                                            fontSize: 12.h,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: discount.status
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            discount.status
                                                ? 'Active'
                                                : 'Inactive',
                                            style: TextStyle(
                                              color: discount.status
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 12.h,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Created: ${_formatDate(discount.createDate)}',
                                          style: TextStyle(
                                            fontSize: 12.h,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            "Use Now",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.h,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: "Discounts"),
          ),
        ],
      ),
    );
  }
}
