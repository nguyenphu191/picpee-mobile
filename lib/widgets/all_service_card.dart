import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';

class AllServicesCard extends StatelessWidget {
  const AllServicesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // List of services to display
    final List<Map<String, dynamic>> services = [
      {"title": "Single Exposure", "icon": AppImages.SingleExportIcon},
      {"title": "Flambient", "icon": AppImages.FlambientIcon},
      {"title": "Blended Brackets (HDR)", "icon": AppImages.HDRIcon},
      {
        "title": "360° Image Enhancement",
        "icon": AppImages.Image360EnhanceIcon,
      },
      {"title": "Virtual Staging", "icon": AppImages.VirtualStaggingIcon},
      {"title": "360° Image", "icon": AppImages.Image360Icon},
      {"title": "Remodel", "icon": AppImages.RemodelIcon},
      {"title": "Day To Dusk", "icon": AppImages.DayToDuckIcon},
      {"title": "Day To Twilight", "icon": AppImages.DayToTwilightIcon},
      {"title": "Cleaning Room", "icon": AppImages.CleanIcon},
      {"title": "1-4 Item", "icon": AppImages.CleanIcon},
      {"title": "Changing Sesions", "icon": AppImages.ChangeSessionIcon},
      {"title": "Water In Pool", "icon": AppImages.WaterInPoolIcon},
      {"title": "Rain To Shine", "icon": AppImages.RainToShineIcon},
      {"title": "Lawn Replacement", "icon": AppImages.LawnReplacementIcon},
      {"title": "Custom 2D", "icon": AppImages.Custom2dIcon},
      {"title": "Custom 3D", "icon": AppImages.Custom3dIcon},
      {"title": "Walkthrough Video", "icon": AppImages.WalkthroughIcon},
      {"title": "Property Video", "icon": AppImages.PropertyIcon},
      {"title": "Reels", "icon": AppImages.ReelsIcon},
      {"title": "Slideshows", "icon": AppImages.SlideShowIcon},
      {"title": "Team", "icon": AppImages.TeamIcon},
      {"title": "Individual", "icon": AppImages.IndividualIcon},
      {"title": "Add Person", "icon": AppImages.AddPersonIcon},
      {"title": "Remove Person", "icon": AppImages.RemovePersonIcon},
      {"title": "Cut Outs", "icon": AppImages.CutsOutIcon},
      {
        "title": "Background Replacement",
        "icon": AppImages.BackgroundReplaceIcon,
      },
      {"title": "Change Color", "icon": AppImages.ChangeColorIcon},
    ];

    // Group services into chunks of 4 for 2x2 grid
    final List<List<Map<String, dynamic>>> serviceChunks = [];
    for (var i = 0; i < services.length; i += 4) {
      serviceChunks.add(
        services.sublist(i, i + 4 > services.length ? services.length : i + 4),
      );
    }

    return ClipPath(
      clipper: TopNotchClipper(),
      child: Container(
        height: 380.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        // margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFEFF), Color(0xFFF4E9F5), Color(0xFFEEEFFA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.r),
            topRight: Radius.circular(5.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Text(
                "All Services",
                style: TextStyle(
                  fontSize: 20.h,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 280.h,
              padding: EdgeInsets.all(8.h),
              child: PageView.builder(
                controller: PageController(viewportFraction: 1),
                itemBuilder: (context, pageIndex) {
                  // dùng modulo để lặp vô hạn
                  final chunk = serviceChunks[pageIndex % serviceChunks.length];
                  return Padding(
                    padding: EdgeInsets.only(right: 3.h),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 3.h,
                        crossAxisSpacing: 3.h,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: chunk.length,
                      itemBuilder: (context, index) {
                        final service = chunk[index];
                        return _buildServiceItem(
                          service['title'],
                          service['icon'],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(String title, String icon) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, height: 48.sp),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class TopNotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    double notchWidth = 120.w; // Notch width
    double notchDepth = 8.w; // Notch depth

    // Start from top-left corner
    path.lineTo((size.width - notchWidth) / 2, 0);
    // Create trapezoid notch
    path.lineTo(size.width / 2 - notchWidth / 3, notchDepth);
    path.lineTo(size.width / 2 + notchWidth / 3, notchDepth);
    path.lineTo((size.width + notchWidth) / 2, 0);
    // Continue with the rest of the edges
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
