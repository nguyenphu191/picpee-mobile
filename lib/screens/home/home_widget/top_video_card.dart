import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/models/service_model.dart';
import 'package:picpee_mobile/screens/home/home_widget/one_video_card.dart';
import 'package:picpee_mobile/screens/photo-services/vendor_service_screen.dart';
import 'package:picpee_mobile/widgets/one_service_card.dart';

class TopVideoCard extends StatefulWidget {
  const TopVideoCard({
    super.key,
    this.onSeeAllTap,
    this.onServiceTap,
    required this.title,
    this.isHome = true,
    this.topDesigners = const [],
  });
  final VoidCallback? onSeeAllTap;
  final Function(ServiceModel)? onServiceTap;
  final String title;
  final bool isHome;
  final List<DesignerModel> topDesigners;
  @override
  State<TopVideoCard> createState() => _TopVideoCardState();
}

class _TopVideoCardState extends State<TopVideoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 80.h,
                  width: widget.isHome ? 240.w : 340.w,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Top Designers In ${widget.title}",
                    style: TextStyle(
                      fontSize: 20.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.4,
                    ),
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
            height: widget.isHome ? 310.h : 360.h,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.topDesigners.length,
              itemBuilder: (context, index) {
                final designer = widget.topDesigners[index];
                return Container(
                  height: widget.isHome ? 300.h : 360.h,
                  width: widget.isHome
                      ? MediaQuery.of(context).size.width - 32.h
                      : 310.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),

                    border: Border.all(color: Colors.grey.shade300, width: 1.0),
                  ),
                  margin: EdgeInsets.only(
                    right: index < widget.topDesigners.length - 1 ? 6.h : 0,
                  ),
                  child: widget.isHome
                      ? OneVideoCard(
                          designer: designer,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VendorServiceScreen(),
                              ),
                            );
                          },
                        )
                      : OneServiceCard(
                          designer: designer,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VendorServiceScreen(),
                              ),
                            );
                          },
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
