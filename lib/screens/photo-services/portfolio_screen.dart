import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/core/utils/service_hard_data.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/models/review_model.dart';
import 'package:picpee_mobile/models/skill_of_vendor_model.dart';
import 'package:picpee_mobile/providers/designer_provider.dart';
import 'package:picpee_mobile/providers/review_provider.dart';
import 'package:picpee_mobile/screens/chat/chat_widget/detail_chat.dart';
import 'package:picpee_mobile/screens/order/order_widget/add_order_card.dart';
import 'package:picpee_mobile/widgets/before_after_card.dart';
import 'package:picpee_mobile/widgets/customer_drawer.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:picpee_mobile/widgets/header.dart';
import 'package:provider/provider.dart';

class Service {
  final String name;
  final int count;
  final String category;

  Service({required this.name, required this.count, required this.category});
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key, required this.vendorId});
  final int vendorId;
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String selectedCategory = 'ALL';
  String selectedSortBy = 'Most Project';
  String selectedFilterBy = 'All stars';

  // Remove hardcoded services - will be generated from API data
  List<Service> get services {
    final designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    final skills = designerProvider.portfolioSkills;

    // Generate services list from API skills
    List<Service> servicesList = [
      Service(name: 'ALL', count: skills.length, category: 'ALL'),
    ];

    Map<String, int> categoryCount = {};
    for (var skill in skills) {
      categoryCount[skill.skillCategory] =
          (categoryCount[skill.skillCategory] ?? 0) + 1;
    }
    categoryCount.forEach((category, count) {
      servicesList.add(
        Service(name: category, count: count, category: category),
      );
    });

    return servicesList;
  }

  List<SkillOfVendorModel> get filteredServiceItems {
    final designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    final skills = designerProvider.portfolioSkills;

    if (selectedCategory == 'ALL') {
      return skills;
    }
    return skills
        .where((skill) => skill.skillCategory == selectedCategory)
        .toList();
  }

  List<ReviewModel> get filteredAndSortedReviews {
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    List<ReviewModel> filtered = List.from(reviewProvider.vendorReview);
    if (selectedFilterBy != 'All stars') {
      int rating = 0;
      switch (selectedFilterBy) {
        case '5 stars':
          rating = 5;
          break;
        case '4 stars':
          rating = 4;
          break;
        case '3 stars':
          rating = 3;
        case '2 stars':
          rating = 2;
        case '1 star':
          rating = 1;

          break;
      }
      filtered = filtered.where((review) => review.rating == rating).toList();
    }

    switch (selectedSortBy) {
      case 'Most Project':
        filtered.sort((a, b) => b.numberOrder.compareTo(a.numberOrder));
        break;
      case 'Latest':
        filtered.sort((a, b) => b.modifiedTime.compareTo(a.modifiedTime));
        break;
      case 'Highest Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.grey[900],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Services',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[400]),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[700]),
                SizedBox(height: 8.h),

                Container(
                  width: double.maxFinite,
                  constraints: BoxConstraints(maxHeight: 300.h),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.h,
                      runSpacing: 8.h,
                      children: services.map((service) {
                        bool isSelected = selectedCategory == service.category;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategory = service.category;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.buttonGreen.withOpacity(0.2)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.buttonGreen
                                    : Colors.grey[600]!,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected)
                                  Padding(
                                    padding: EdgeInsets.only(right: 6.w),
                                    child: Icon(
                                      Icons.check,
                                      color: AppColors.buttonGreen,
                                      size: 14.h,
                                    ),
                                  ),
                                Text(
                                  '${_formatCate(service.name)}',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[400],
                                    fontSize: 14.h,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
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

  List<Map<String, String>> titleDescriptionPairs = getTitleDescriptionPairs();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPortfolio();
      fetchReviews();
    });
  }

  Future<void> fetchPortfolio() async {
    print("Fetch portfolio for vendorId: ${widget.vendorId}");
    final designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    final res = await designerProvider.fetchPortfolio(widget.vendorId);
    if (!res && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load portfolio'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchReviews({int page = 1, int limit = 10}) async {
    print('fetchReviews called: page=$page, limit=$limit');
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    final res = await reviewProvider.fetchReviewOfVendor(
      widget.vendorId,
      page: page,
      limit: limit,
    );
    print(
      'fetchReviews result: $res, total reviews: ${reviewProvider.vendorReview.length}',
    );
    if (!res && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load reviews'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomEndDrawer(),
      body: Consumer2<DesignerProvider, ReviewProvider>(
        builder: (context, designerProvider, reviewProvider, child) {
          if (designerProvider.isLoading) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.buttonGreen,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16.h, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          final designer = designerProvider.selectedDesigner;
          final skills = designerProvider.portfolioSkills;

          if (designer == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.h, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load portfolio',
                      style: TextStyle(fontSize: 16.h, color: Colors.grey),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        fetchPortfolio();
                        fetchReviews();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await fetchPortfolio();
              await fetchReviews();
            },
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: const Color.fromARGB(239, 0, 0, 0),
                          padding: EdgeInsets.all(16.h),
                          child: Column(
                            children: [
                              SizedBox(height: 100.h),
                              Row(
                                children: [
                                  Container(
                                    width: 68.h,
                                    height: 68.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: designer.avatar.isNotEmpty
                                          ? Image.network(
                                              designer.avatar,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 24.w,
                                                      height: 24.h,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(Colors.white),
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
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[700],
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                        size: 32.h,
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Container(
                                              color: Colors.grey[700],
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 32.h,
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          designer.businessName.isNotEmpty
                                              ? designer.businessName
                                              : '${designer.firstname} ${designer.lastname}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.h,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.orange,
                                              size: 16.h,
                                            ),
                                            SizedBox(width: 5.w),
                                            Row(
                                              children: [
                                                Text(
                                                  '${_formatPrice(designer.ratingPoint)} ',
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 14.h,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '(${designer.totalReview} reviews)',
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 14.h,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          children: [
                                            // Update the flag image section
                                            if (designer.imageFlag.isNotEmpty)
                                              Container(
                                                width: 25.w,
                                                height: 15.h,
                                                child: Image.network(
                                                  designer.imageFlag,
                                                  height: 15.h,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Container(
                                                      width: 25.w,
                                                      height: 15.h,
                                                      color: Colors.grey[300],
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 12.w,
                                                          height: 12.h,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 1.5,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                  Color
                                                                >(
                                                                  Colors
                                                                      .grey[600]!,
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
                                                          width: 25.w,
                                                          height: 15.h,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  2,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              designer
                                                                  .countryCode,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                ),
                                              ),
                                            SizedBox(width: 16.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: designer
                                                      .getStatusColor(),
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    designer
                                                        .getStatusIcon()
                                                        .icon,
                                                    color: designer
                                                        .getStatusColor(),
                                                    size: 16.h,
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  Text(
                                                    designer
                                                        .getStatusReceiveOrder(),
                                                    style: TextStyle(
                                                      color: Colors.grey[400],
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
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.h,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${designer.totalFavorite}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 18.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.h,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${designer.totalReview}',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Icon(
                                          Icons.chat,
                                          color: Color(0xff2ABFD5),
                                          size: 18.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () => _showFilterDialog(),
                                    child: Container(
                                      padding: EdgeInsets.all(6.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Icon(
                                        Icons.filter_list,
                                        color: AppColors.buttonGreen,
                                        size: 20.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Services List
                        Container(
                          child: Column(
                            children: [
                              if (skills.isEmpty)
                                Container(
                                  padding: EdgeInsets.all(40.h),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.work_off,
                                        size: 64.h,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'No services available',
                                        style: TextStyle(
                                          fontSize: 16.h,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: filteredServiceItems.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 12.h),
                                    itemBuilder: (context, index) {
                                      final skill = filteredServiceItems[index];
                                      return _buildServiceItem(skill, designer);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        _buildReviewsSection(),

                        // Footer
                        Footer(),
                      ],
                    ),
                  ),
                ),

                // Chat button
                Positioned(
                  top: 118.h,
                  right: 26.w,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailChat(
                            user: {
                              'id': designer.userId.toString(),
                              'name': designer.businessName.isNotEmpty
                                  ? designer.businessName
                                  : '${designer.firstname} ${designer.lastname}',
                              'avatar': designer.avatar,
                            },
                            onClose: () => Navigator.of(context).pop(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 50.h,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat,
                        color: Color(0xff2ABFD5),
                        size: 32.h,
                      ),
                    ),
                  ),
                ),

                // Header
                Positioned(top: 30.h, left: 16.w, right: 16.w, child: Header()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceItem(SkillOfVendorModel skill, DesignerModel designer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.buttonGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: skill.urlImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            skill.urlImage.trim(),
                            width: 40.h,
                            height: 40.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 40.h,
                                height: 40.h,
                                color: AppColors.buttonGreen.withOpacity(0.1),
                                child: Center(
                                  child: SizedBox(
                                    width: 16.w,
                                    height: 16.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.buttonGreen,
                                      ),
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.photo_camera,
                                color: AppColors.buttonGreen,
                                size: 20.h,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.photo_camera,
                          color: AppColors.buttonGreen,
                          size: 20.h,
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.skillName,
                        style: TextStyle(
                          fontSize: 16.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (skill.skillDescription.isNotEmpty)
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(20.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          skill.skillName,
                                          style: TextStyle(
                                            fontSize: 18.h,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          skill.skillDescription,
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            color: Colors.black87,
                                            height: 1.4,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Close'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            'What\'s included?',
                            style: TextStyle(
                              fontSize: 12.h,
                              color: AppColors.linkBlue,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${_formatPrice(skill.cost)}",
                      style: TextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.bold,
                        color: AppColors.linkBlue,
                      ),
                    ),
                    Text(
                      'per photo',
                      style: TextStyle(fontSize: 12.h, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            height: 200.h,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  // Background loading indicator for BeforeAfterCard
                  Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 32.w,
                            height: 32.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey[600]!,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Loading images...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // BeforeAfterCard on top
                  BeforeAfterCard(skillOfVendor: skill, height: 200.h),
                ],
              ),
            ),
          ),

          // Service Details
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Capacity',
                          style: TextStyle(
                            fontSize: 12.h,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${skill.numberImage} per day',
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Turnaround time',
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 4.w),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(20.h),
                                        child: Text(
                                          "Turnaround time is determined by the vendor. Turnaround time starts from the time the vendor accepts the order until the delivery. Modifications do not affect the turnaround time.",
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            color: Colors.black87,
                                            height: 1.3,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.info_outline,
                                size: 16.h,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${skill.turnaroundTime} hours',
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AddOrderCard(designer: designer, skill: skill),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Start Order',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Update the _buildReviewsSection method to use Consumer
  Widget _buildReviewsSection() {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        if (reviewProvider.isLoading) {
          return Container(
            color: Colors.black,
            padding: EdgeInsets.all(20.h),
            child: Column(
              children: [
                Text(
                  'Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.h,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40.h),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Loading reviews...',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14.h),
                ),
              ],
            ),
          );
        }

        final displayedReviews = filteredAndSortedReviews;

        return Container(
          color: Colors.black,
          child: Container(
            padding: EdgeInsets.all(20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Reviews',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                if (reviewProvider.vendorReview.isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          'Sort By',
                          selectedSortBy,
                          ['Most Project', 'Latest', 'Highest Rating'],
                          (value) {
                            setState(() {
                              selectedSortBy = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildDropdown(
                          'Filter by',
                          selectedFilterBy,
                          [
                            'All stars',
                            '5 stars',
                            '4 stars',
                            '3 stars',
                            '2 stars',
                            '1 star',
                          ],
                          (value) {
                            setState(() {
                              selectedFilterBy = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],

                if (reviewProvider.vendorReview.isEmpty)
                  Container(
                    padding: EdgeInsets.all(40.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 64.h,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No reviews yet',
                          style: TextStyle(
                            fontSize: 18.h,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Be the first to leave a review!',
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                else if (displayedReviews.isEmpty)
                  Container(
                    padding: EdgeInsets.all(40.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.filter_list_off,
                          size: 64.h,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No reviews match your filters',
                          style: TextStyle(fontSize: 16.h, color: Colors.grey),
                        ),
                        SizedBox(height: 8.h),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedFilterBy = 'All stars';
                            });
                          },
                          child: Text(
                            'Clear filters',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: displayedReviews.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return _buildReviewItem(displayedReviews[index]);
                    },
                  ),

                  // Load More Button
                  if (reviewProvider.hasMoreReviews) ...[
                    SizedBox(height: 24.h),
                    Center(
                      child: reviewProvider.isLoadingMore
                          ? Column(
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Loading more reviews...',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14.h,
                                  ),
                                ),
                              ],
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                final success = await reviewProvider
                                    .loadMoreReviews(widget.vendorId);
                                if (!success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to load more reviews',
                                      ),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 24.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Load more',
                                style: TextStyle(
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[600]!, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[400], fontSize: 12.h),
            ),
            DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: SizedBox(),
              dropdownColor: Colors.grey[800],
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.h,
                fontWeight: FontWeight.w500,
              ),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    DateTime reviewDate = DateTime.fromMillisecondsSinceEpoch(
      review.modifiedTime,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 45.h,
                  height: 45.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: review.reviewer.avatar.isEmpty
                        ? Colors.green
                        : Colors.grey[300],
                  ),
                  child: ClipOval(
                    child: review.reviewer.avatar.isNotEmpty
                        ? Image.network(
                            review.reviewer.avatar,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey[600]!,
                                      ),
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.green,
                                child: Center(
                                  child: Text(
                                    review.reviewer.businessName.isNotEmpty
                                        ? review.reviewer.businessName
                                              .substring(0, 1)
                                              .toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              review.reviewer.businessName.isNotEmpty
                                  ? review.reviewer.businessName
                                        .substring(0, 1)
                                        .toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12.w),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewer.businessName.isNotEmpty
                            ? review.reviewer.businessName
                            : 'Anonymous User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.h,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Updated on ${_formatDate(reviewDate)}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),

            Text(
              review.comment.isNotEmpty
                  ? review.comment
                  : 'No comment provided.',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14.h,
                height: 1.4,
              ),
            ),
            SizedBox(height: 12.h),

            // Rating and Order Count
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 18.h,
                      color: index < review.rating
                          ? Colors.orange
                          : Colors.grey[600],
                    );
                  }),
                ),
                SizedBox(width: 8.w),
                Text(
                  '(${review.numberOrder} orders)',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12.h),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatCate(String cate) {
    switch (cate) {
      case 'ALL':
        return 'All';
      case 'IMAGE_ENHANCEMENT':
        return 'Image Enhancement';
      case 'VIRTUAL_STAGING':
        return 'Virtual Staging';
      case 'DAY_TO_DUSK':
        return 'Day to Dusk';
      case 'DAY_TO_TWILIGHT':
        return 'Day to Twilight';
      case 'OBJECT_REMOVAL':
        return 'Object Removal';
      case 'CHANGING_SEASONS':
        return 'Changing Seasons';
      case 'WATER_IN_POOL':
        return 'Water in Pool';
      case 'LAWN_REPLACEMENT':
        return 'Lawn Replacement';
      case 'RAIN_TO_SHINE':
        return 'Rain to Shine';
      case 'PROPERTY_VIDEOS_SERVICES':
        return 'Property Videos Services';
      default:
        return cate;
    }
  }
}
