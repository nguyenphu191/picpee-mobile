import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/models/service_model.dart';
import 'package:picpee_mobile/screens/photo-services/portfolio_screen.dart';
import 'package:picpee_mobile/widgets/one_service_card.dart';

class TopServiceCard extends StatefulWidget {
  const TopServiceCard({
    super.key,
    this.onSeeAllTap,
    this.onServiceTap,
    required this.title,
    this.isDuck = false,
    this.isHome = true,
    this.topDesigners = const [],
  });
  final VoidCallback? onSeeAllTap;
  final Function(ServiceModel)? onServiceTap;
  final String title;
  final bool isDuck;
  final bool isHome;
  final List<DesignerModel> topDesigners;

  @override
  State<TopServiceCard> createState() => _TopServiceCardState();
}

class _TopServiceCardState extends State<TopServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
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
                      fontSize: 20.h,
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
                              fontSize: 14.h,
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
              itemCount: widget.topDesigners.length,
              itemBuilder: (context, index) {
                final designer = widget.topDesigners[index];
                return Container(
                  width: 320.w,
                  margin: EdgeInsets.only(
                    right: index < widget.topDesigners.length - 1 ? 4.h : 0,
                  ),
                  child: OneServiceCard(
                    designer: designer,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PortfolioScreen(vendorId: designer.userId),
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
