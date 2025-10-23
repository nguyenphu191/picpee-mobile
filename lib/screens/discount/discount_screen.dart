import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/discount_model.dart';
import 'package:picpee_mobile/providers/discount_provider.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';
import 'package:provider/provider.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDiscounts();
    });
  }

  Future<void> _fetchDiscounts() async {
    final discountProvider = Provider.of<DiscountProvider>(
      context,
      listen: false,
    );
    final success = await discountProvider.fetchAllDiscounts();
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load discounts'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hàm copy mã giảm giá vào clipboard
  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied "$code" to clipboard',
          style: TextStyle(color: Colors.black),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.buttonGreen,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Hàm lọc danh sách discount theo từ khóa tìm kiếm
  List<DiscountModel> _filterDiscounts(List<DiscountModel> discounts) {
    if (_searchQuery.isEmpty) {
      return discounts;
    }

    final query = _searchQuery.toLowerCase().trim();

    return discounts.where((discount) {
      // Tìm kiếm theo mã giảm giá (code)
      final matchesCode = discount.code.toLowerCase().contains(query);

      // Tìm kiếm theo tên designer (business name)
      final matchesDesigner =
          discount.vendor?.businessName.toLowerCase().contains(query) ?? false;

      return matchesCode || matchesDesigner;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DiscountProvider>(
      builder: (context, discountProvider, child) {
        // Lọc danh sách discount dựa trên từ khóa tìm kiếm
        List<DiscountModel> filteredDiscounts = _filterDiscounts(
          discountProvider.discounts,
        );

        return Scaffold(
          backgroundColor: Colors.grey[50],
          drawer: const SideBar(selectedIndex: 2),
          body: Stack(
            children: [
              Positioned(
                top: 80.h,
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
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
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
                                        _searchQuery = '';
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
                        child: filteredDiscounts.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64.h,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      _searchQuery.isEmpty
                                          ? 'No discounts available'
                                          : 'No results found for "$_searchQuery"',
                                      style: TextStyle(
                                        fontSize: 16.h,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (_searchQuery.isNotEmpty) ...[
                                      SizedBox(height: 8.h),
                                      Text(
                                        'Try searching with different keywords',
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            : ListView.builder(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        discount.code,
                                                        style: TextStyle(
                                                          fontSize: 14.h,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      InkWell(
                                                        onTap: () =>
                                                            _copyToClipboard(
                                                              discount.code,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                4.h,
                                                              ),
                                                          child: Icon(
                                                            Icons.copy,
                                                            size: 16.h,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '- ${_formatPrice(discount.discountValue)}',
                                                        style: TextStyle(
                                                          fontSize: 14.h,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        discount.discountType ==
                                                                'PERCENTAGE'
                                                            ? '%'
                                                            : '\$',
                                                        style: TextStyle(
                                                          fontSize: 14.h,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.h),
                                              Row(
                                                children: [
                                                  ClipOval(
                                                    child: Image.network(
                                                      discount.vendor!.avatar
                                                          .trim(),
                                                      width: 28.h,
                                                      height: 28.h,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder:
                                                          (
                                                            context,
                                                            child,
                                                            loadingProgress,
                                                          ) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return Center(
                                                              child: SizedBox(
                                                                width: 20.h,
                                                                height: 20.h,
                                                                child: CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                  valueColor:
                                                                      AlwaysStoppedAnimation<
                                                                        Color
                                                                      >(
                                                                        AppColors
                                                                            .buttonGreen,
                                                                      ),
                                                                  value:
                                                                      loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                      : null,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              width: 24.h,
                                                              height: 24.h,
                                                              color: Colors
                                                                  .grey[300],
                                                              child: Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .white,
                                                                size: 16.h,
                                                              ),
                                                            );
                                                          },
                                                    ),
                                                  ),

                                                  SizedBox(width: 16.w),
                                                  Text(
                                                    discount
                                                        .vendor!
                                                        .businessName,
                                                    style: TextStyle(
                                                      fontSize: 14.h,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12.w,
                                                          vertical: 4.h,
                                                        ),

                                                    child: Text(
                                                      'Activated',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 14.h,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.h),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Created: ${discount.createdTime.substring(0, 10)}',
                                                    style: TextStyle(
                                                      fontSize: 12.h,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  // Container(
                                                  //   padding:
                                                  //       EdgeInsets.symmetric(
                                                  //         horizontal: 8.w,
                                                  //         vertical: 4.h,
                                                  //       ),
                                                  //   decoration: BoxDecoration(
                                                  //     color: Colors.black,
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //           4,
                                                  //         ),
                                                  //   ),
                                                  //   child: Text(
                                                  //     "Use Now",
                                                  //     style: TextStyle(
                                                  //       color: Colors.white,
                                                  //       fontSize: 14.h,
                                                  //       fontWeight:
                                                  //           FontWeight.w600,
                                                  //     ),
                                                  //   ),
                                                  // ),
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
              if (discountProvider.isLoading)
                Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.black.withOpacity(0.3),
                ),
              if (discountProvider.isLoading)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10.r,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.buttonGreen),
                        SizedBox(height: 8.h),
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
