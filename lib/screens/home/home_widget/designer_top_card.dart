import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/providers/designer_provider.dart';
import 'package:picpee_mobile/screens/photo-services/portfolio_screen.dart';
import 'package:provider/provider.dart';

class DesignerTopCardCard extends StatefulWidget {
  const DesignerTopCardCard({super.key});

  @override
  _DesignerTopCardCardState createState() => _DesignerTopCardCardState();
}

class _DesignerTopCardCardState extends State<DesignerTopCardCard> {
  PageController _pageController = PageController();
  int _selectedTab = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBusiness();
      fetchIndividual();
    });
  }

  Future<void> fetchBusiness() async {
    print('Fetching business designers from widget...');
    final DesignerProvider designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    final success = await designerProvider.fetchBusinessDesigners();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load business designers'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchIndividual() async {
    final DesignerProvider designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    final success = await designerProvider.fetchIndividualDesigners();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load individual designers'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  // Get current designers based on selected tab
  List<DesignerModel> get currentDesigners {
    final designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    return _selectedTab == 0
        ? designerProvider.businessDesigners
        : designerProvider.individualDesigners;
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
    return Consumer<DesignerProvider>(
      builder: (context, designerProvider, child) {
        if (designerProvider.isLoading) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 60.h),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          );
        }

        final List<DesignerModel> businessDesigners =
            designerProvider.businessDesigners;
        final List<DesignerModel> individualDesigners =
            designerProvider.individualDesigners;

        // Check if both lists are empty
        if (businessDesigners.isEmpty && individualDesigners.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_off, size: 64.h, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No designers available',
                  style: TextStyle(fontSize: 16.h, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                "Access verified\nDesigners globally",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.h,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              _buildTabSwitcher(businessDesigners, individualDesigners),
              SizedBox(height: 16.h),
              Container(
                height: 300.h,
                child: _buildDesignerPageView(
                  businessDesigners,
                  individualDesigners,
                ),
              ),
              SizedBox(height: 16.h),
              _buildPageIndicator(),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabSwitcher(
    List<DesignerModel> businessDesigners,
    List<DesignerModel> individualDesigners,
  ) {
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
              onTap: businessDesigners.isNotEmpty ? () => _updateTab(0) : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? AppColors.buttonGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Business",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: businessDesigners.isEmpty
                        ? Colors.grey
                        : (_selectedTab == 0 ? Colors.black : Colors.white),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.h,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: individualDesigners.isNotEmpty
                  ? () => _updateTab(1)
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? AppColors.buttonGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Individual",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: individualDesigners.isEmpty
                        ? Colors.grey
                        : (_selectedTab == 1 ? Colors.black : Colors.white),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignerPageView(
    List<DesignerModel> businessDesigners,
    List<DesignerModel> individualDesigners,
  ) {
    final List<DesignerModel> currentDesigners = _selectedTab == 0
        ? businessDesigners
        : individualDesigners;

    if (currentDesigners.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 48.h, color: Colors.grey),
            SizedBox(height: 12.h),
            Text(
              'No ${_selectedTab == 0 ? "business" : "individual"} designers available',
              style: TextStyle(fontSize: 14.h, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: currentDesigners.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        DesignerModel designer = currentDesigners[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: _buildDesignerCard(designer),
        );
      },
    );
  }

  Widget _buildDesignerCard(DesignerModel designer) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PortfolioScreen(vendorId: designer.userId),
          ),
        );
      },
      child: Container(
        height: 300.h,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Stack(
          children: [
            // Bottom card with designer info
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
                        Flexible(
                          child: Text(
                            designer.businessName.isNotEmpty
                                ? designer.businessName
                                : '${designer.firstname} ${designer.lastname}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.h,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (designer.imageFlag.isNotEmpty == true) ...[
                          SizedBox(width: 8),
                          Image.network(
                            designer.imageFlag.trim(),
                            width: 20.w,
                            height: 15.h,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: SizedBox(
                                    width: 15.w,
                                    height: 15.h,
                                    child: CircularProgressIndicator(
                                      color: AppColors.buttonGreen,
                                      strokeWidth: 2,
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
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox.shrink();
                            },
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Skill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white70, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            designer.imageSkill.trim(),
                            height: 20.h,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      color: AppColors.buttonGreen,
                                      strokeWidth: 2,
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
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 16.h);
                            },
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            designer.skillName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.h,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Rating and price section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18.h,
                              ),
                              SizedBox(width: 4.h),
                              Row(
                                children: [
                                  Text(
                                    "${designer.ratingPoint.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    " (${designer.totalReview})",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.h,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Starting at  ",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.h,
                                ),
                              ),
                              Text(
                                "\$${_formatPrice(designer.cost)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.h,
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

            // Cover image
            Container(
              height: 140.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: designer.imageCover.isNotEmpty
                    ? Image.network(
                        designer.imageCover.trim(),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade300,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.buttonGreen,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: Icon(
                              Icons.image,
                              size: 48.h,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.image,
                          size: 48.h,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            // Avatar
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
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: designer.avatar.isNotEmpty
                          ? Image.network(
                              designer.avatar.trim(),
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.buttonGreen,
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
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.person,
                                    size: 32.h,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.person,
                                size: 32.h,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    final List<DesignerModel> currentDesigners = _selectedTab == 0
        ? Provider.of<DesignerProvider>(
            context,
            listen: false,
          ).businessDesigners
        : Provider.of<DesignerProvider>(
            context,
            listen: false,
          ).individualDesigners;

    if (currentDesigners.isEmpty) {
      return SizedBox.shrink();
    }

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
