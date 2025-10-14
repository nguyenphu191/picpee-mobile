import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/models/skill_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/providers/skill_provider.dart';
import 'package:picpee_mobile/screens/photo-services/all_services_screen.dart';
import 'package:provider/provider.dart';

class AllServicesCard extends StatelessWidget {
  const AllServicesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, skillProvider, child) {
        final List<SkillModel> skillModels = skillProvider.getAllTopDesigners;

        if (skillModels.isEmpty) {
          return const SizedBox.shrink(); // Hoặc hiển thị thông báo nếu không có dữ liệu
        }

        final int itemsPerPage = 4;
        final int totalPages = (skillModels.length / itemsPerPage).ceil();

        return ClipPath(
          clipper: TopNotchClipper(),
          child: Container(
            height: 325.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFEFF),
                  Color(0xFFF4E9F5),
                  Color(0xFFEEEFFA),
                ],
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "All Services",
                    style: TextStyle(
                      fontSize: 24.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 240.h,
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  alignment: Alignment.topCenter,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 1),
                    itemCount: null, // Để tạo vòng lặp vô hạn
                    itemBuilder: (context, pageIndex) {
                      final int effectivePage = pageIndex % totalPages;
                      final int startIndex = effectivePage * itemsPerPage;
                      final int endIndex = (startIndex + itemsPerPage).clamp(
                        0,
                        skillModels.length,
                      );
                      final List<SkillModel> pageSkills = skillModels.sublist(
                        startIndex,
                        endIndex,
                      );

                      return Padding(
                        padding: EdgeInsets.only(right: 3.h),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 3.h,
                                crossAxisSpacing: 3.h,
                                childAspectRatio: 1.4,
                              ),
                          itemCount: pageSkills.length,
                          itemBuilder: (context, index) {
                            final service = pageSkills[index];
                            return _buildServiceItem(
                              service.skill!.name,
                              service.skill!.urlImage,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllServicesScreen(
                                      title: service.skill!.name,
                                      skillId: service
                                          .skill!
                                          .id, // Chuyển id sang String nếu cần
                                    ),
                                  ),
                                );
                              },
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
      },
    );
  }

  Widget _buildServiceItem(String title, String icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              icon,
              height: 40.h,
              width: 40.h,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(icon.trim(), height: 40.h, width: 40.h);
              },
            ),
            SizedBox(height: 5.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.h,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
