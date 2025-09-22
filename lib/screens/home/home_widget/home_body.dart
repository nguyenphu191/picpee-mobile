import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/screens/home/home_widget/all_service_card.dart';
import 'package:picpee_mobile/screens/home/home_widget/designer_top_card.dart';
import 'package:picpee_mobile/screens/home/home_widget/featured_card.dart';
import 'package:picpee_mobile/screens/photo-services/all_services_screen.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:picpee_mobile/widgets/top_service_card.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 750.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 400.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.background1),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 100.h),
                          Text(
                            "LAUNCHING 2025",
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 14.h,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              "Transform Your Real Estate Photos with Professional Editing.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.h,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Subtitle
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.h),
                            child: Text(
                              "Boost your listings with crisp, vibrant images from our skilled freelancers.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14.h,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Search box
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 45.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: Colors.grey.shade700,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: TextField(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.h,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Search marketplace",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Container(
                                  height: 45.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.h,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.buttonGreen,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    "Search",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.h,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 360.h,
                    left: 0,
                    right: 0,
                    child: AllServicesCard(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            DesignerTopCardCard(),
            FeaturedCard(),
            SizedBox(height: 20.h),
            TopServiceCard(
              title: "Blanded Brackets (HDR)",
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllServicesScreen(title: "Blanded Brackets (HDR)"),
                  ),
                );
              },
            ),
            SizedBox(height: 10.h),
            TopServiceCard(
              title: "Virtual Staging",
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllServicesScreen(title: "Virtual Staging"),
                  ),
                );
              },
            ),
            SizedBox(height: 10.h),
            TopServiceCard(
              title: "Room Cleaning",
              isDuck: true,
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllServicesScreen(title: "Room Cleaning"),
                  ),
                );
              },
            ),
            SizedBox(height: 10.h),
            TopServiceCard(
              title: "Day To Duck",
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllServicesScreen(title: "Day To Duck"),
                  ),
                );
              },
            ),
            SizedBox(height: 10.h),
            Footer(),
          ],
        ),
      ),
    );
  }
}
