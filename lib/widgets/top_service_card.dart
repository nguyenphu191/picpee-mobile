import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/service_model.dart';
import 'package:picpee_mobile/screens/photo-services/vendor_service_screen.dart';
import 'package:picpee_mobile/widgets/one_service_card.dart';

class TopServiceCard extends StatefulWidget {
  const TopServiceCard({
    super.key,
    this.onSeeAllTap,
    this.onServiceTap,
    required this.title,
    this.isDuck = false,
    this.isHome = true,
  });
  final VoidCallback? onSeeAllTap;
  final Function(ServiceModel)? onServiceTap;
  final String title;
  final bool isDuck;
  final bool isHome;

  @override
  State<TopServiceCard> createState() => _TopServiceCardState();
}

class _TopServiceCardState extends State<TopServiceCard> {
  static final List<ServiceModel> _hardcodedServices = [
    ServiceModel(
      title: "Top Designers In\nBlended Brackets\n(HDR)",
      beforeImageUrl:
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      afterImageUrl:
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
      rating: 5.0,
      reviewCount: 31,
      turnaroundTime: "12 hours",
      startingPrice: 0.75,
      designer: Designer(
        name: "Designer 1",
        avatarUrl:
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.5,
        completedOrders: 120,
        isAutoAccepting: true,
      ),
    ),
    ServiceModel(
      title: "Professional Photo\nRetouching\n(Premium)",
      beforeImageUrl:
          "https://images.unsplash.com/photo-1600298881974-6be191ceeda1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      afterImageUrl:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
      rating: 4.9,
      reviewCount: 127,
      turnaroundTime: "24 hours",
      startingPrice: 2.50,
      designer: Designer(
        name: "Designer 2",
        avatarUrl:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.7,
        completedOrders: 200,
        isAutoAccepting: true,
      ),
    ),
    ServiceModel(
      title: "AI-Enhanced\nPortrait Editing\n(Express)",
      beforeImageUrl:
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      afterImageUrl:
          "https://images.unsplash.com/photo-1494790108755-2616b612b605?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
      rating: 4.8,
      reviewCount: 89,
      turnaroundTime: "6 hours",
      startingPrice: 1.25,
      designer: Designer(
        name: "Designer 3",
        avatarUrl:
            "https://images.unsplash.com/photo-1494790108755-2616b612b605?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.6,
        completedOrders: 150,
        isAutoAccepting: true,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        color: widget.isDuck ? AppColors.brandDuckGreen : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: widget.isHome ? 240.w : 340.w,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Top Designers In ${widget.title}",
                    style: TextStyle(
                      fontSize: 22.h,
                      fontWeight: FontWeight.bold,
                      color: !widget.isDuck ? Colors.black : Colors.white,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                widget.isHome
                    ? InkWell(
                        onTap: widget.onSeeAllTap,
                        child: Container(
                          height: 42.h,
                          width: 90.w,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.buttonGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.h,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Container(
            height: 360.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _hardcodedServices.length,
              itemBuilder: (context, index) {
                final service = _hardcodedServices[index];
                return Container(
                  width: 320.w,
                  margin: EdgeInsets.only(
                    right: index < _hardcodedServices.length - 1 ? 4.h : 0,
                  ),
                  child: OneServiceCard(
                    service: service,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VendorServiceScreen(),
                        ),
                      );
                    },
                    isDuck: widget.isDuck,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
