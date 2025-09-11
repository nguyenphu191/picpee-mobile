import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';

class DesignerTopCardCard extends StatefulWidget {
  @override
  _DesignerTopCardCardState createState() => _DesignerTopCardCardState();
}

class _DesignerTopCardCardState extends State<DesignerTopCardCard> {
  PageController _pageController = PageController();
  int _selectedTab = 0; // 0 for Business, 1 for Individual
  int _currentPage = 0;

  List<Designer> businessDesigners = [
    Designer(
      name: "The Best Editor",
      rating: 5.0,
      reviewCount: 31,
      price: 0.56,
      image: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400",
      profileImage:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
      hasVerified: true,
    ),
    Designer(
      name: "Creative Studio",
      rating: 4.9,
      reviewCount: 45,
      price: 0.75,
      image:
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400",
      profileImage:
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100",
      hasVerified: true,
    ),
    Designer(
      name: "Design Pro",
      rating: 4.8,
      reviewCount: 28,
      price: 0.62,
      image:
          "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=400",
      profileImage:
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
      hasVerified: true,
    ),
  ];

  List<Designer> individualDesigners = [
    Designer(
      name: "J.M.Designs",
      rating: 5.0,
      reviewCount: 17,
      price: 0.46,
      image:
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400",
      profileImage:
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
      hasVerified: true,
      flag: "🇺🇸",
    ),
    Designer(
      name: "Alex Creative",
      rating: 4.9,
      reviewCount: 23,
      price: 0.52,
      image: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400",
      profileImage:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
      hasVerified: true,
      flag: "🇬🇧",
    ),
    Designer(
      name: "Sarah Design",
      rating: 4.7,
      reviewCount: 19,
      price: 0.48,
      image:
          "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=400",
      profileImage:
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100",
      hasVerified: true,
      flag: "🇨🇦",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        int designersLength = _selectedTab == 0
            ? businessDesigners.length
            : individualDesigners.length;
        int newPage = (_pageController.page ?? 0).round() % designersLength;
        if (newPage != _currentPage) {
          setState(() {
            _currentPage = newPage;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateTab(int tab) {
    setState(() {
      _selectedTab = tab;
      _currentPage = 0;
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 610.h,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFEFF), Color(0xFFEDF5E9), Color(0xFFF5FAEE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),
      child: Column(
        children: [
          // Title
          Text(
            "Access verified\nDesigners globally",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.h,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.5,
            ),
          ),
          SizedBox(height: 30.h),
          _buildTabSwitcher(),
          SizedBox(height: 30.h),
          Container(height: 300.h, child: _buildDesignerPageView()),
          SizedBox(height: 30.h),
          _buildPageIndicator(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      height: 56.h,
      margin: EdgeInsets.symmetric(horizontal: 60.h),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _updateTab(0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? AppColors.buttonGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "Business",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedTab == 0 ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.h,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _updateTab(1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? AppColors.buttonGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "Individual",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedTab == 1 ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignerPageView() {
    List<Designer> currentDesigners = _selectedTab == 0
        ? businessDesigners
        : individualDesigners;

    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        // Infinite loop logic
        Designer designer = currentDesigners[index % currentDesigners.length];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: _buildDesignerCard(designer),
        );
      },
    );
  }

  Widget _buildDesignerCard(Designer designer) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      child: Stack(
        children: [
          Positioned(
            top: 110.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 45.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        designer.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (designer.flag != null) ...[
                        SizedBox(width: 8),
                        Text(designer.flag!, style: TextStyle(fontSize: 16.h)),
                      ],
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Color.fromARGB(255, 167, 167, 167),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppImages.SingleExportIcon, height: 16.h),
                        SizedBox(width: 5),
                        Text(
                          "Single Exposure",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 18.h),
                            SizedBox(width: 4.h),
                            Text(
                              "${designer.rating} (${designer.reviewCount})",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.h,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Starting at ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.h,
                              ),
                            ),
                            Text(
                              "\$${designer.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 140.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(designer.image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 70.h,
                width: 70.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: 5,
                  ),
                ),
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(designer.profileImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Designer> currentDesigners = _selectedTab == 0
        ? businessDesigners
        : individualDesigners;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(currentDesigners.length, (index) {
        return Container(
          width: index == _currentPage ? 36 : 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index == _currentPage
                ? Color(0xFF2A2A2A)
                : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class Designer {
  final String name;
  final double rating;
  final int reviewCount;
  final double price;
  final String image;
  final String profileImage;
  final bool hasVerified;
  final String? flag;

  Designer({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.image,
    required this.profileImage,
    required this.hasVerified,
    this.flag,
  });
}
