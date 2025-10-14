import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/providers/skill_provider.dart';
import 'package:picpee_mobile/screens/home/home_widget/all_service_card.dart';
import 'package:picpee_mobile/screens/home/home_widget/designer_top_card.dart';
import 'package:picpee_mobile/screens/home/home_widget/featured_card.dart';
import 'package:picpee_mobile/screens/home/home_widget/top_video_card.dart';
import 'package:picpee_mobile/screens/photo-services/all_services_screen.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:picpee_mobile/widgets/top_service_card.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTopDesigners();
    });
  }

  Future<void> _fetchTopDesigners() async {
    try {
      bool success = await Provider.of<SkillProvider>(
        context,
        listen: false,
      ).fetchTopDesignersBySkill();
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load top designers'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: _fetchTopDesigners,
        child: Consumer<SkillProvider>(
          builder: (context, skillProvider, child) {
            final hdrDesigners =
                skillProvider.hdrTopDesigner?.topDesigners ?? [];
            final vhsDesigners =
                skillProvider.vhsTopDesigner?.topDesigners ?? [];
            final propertyDesigners =
                skillProvider.propertyTopDesigner?.topDesigners ?? [];
            final cleaningDesigners =
                skillProvider.cleaningTopDesigner?.topDesigners ?? [];
            final dtdDesigners =
                skillProvider.dtdTopDesigner?.topDesigners ?? [];
            final skillModels = skillProvider.getHaveTopDesigners;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 685.h,
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
                                    SizedBox(height: 110.h),
                                    Text(
                                      "LAUNCHING 2025",
                                      style: TextStyle(
                                        color: Colors.grey.shade300,
                                        fontSize: 12.h,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.h,
                                      ),
                                      child: Text(
                                        "Boost your listings with crisp, vibrant images from our skilled freelancers.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 14.h,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),

                                    // Search box
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.h,
                                      ),
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
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
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
                                                  hintText:
                                                      "Search marketplace",
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
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
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
                      DesignerTopCardCard(),
                      FeaturedCard(skillModels: skillModels),
                      SizedBox(height: 20.h),
                      TopServiceCard(
                        title: "Blanded Brackets (HDR)",
                        topDesigners: hdrDesigners,
                        onSeeAllTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllServicesScreen(
                                title: "Blanded Brackets (HDR)",
                                skillId:
                                    skillProvider.hdrTopDesigner!.skill?.id ??
                                    0,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      TopServiceCard(
                        title: "Virtual Staging",
                        topDesigners: vhsDesigners,
                        onSeeAllTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllServicesScreen(
                                title: "Virtual Staging",
                                skillId:
                                    skillProvider.vhsTopDesigner!.skill?.id ??
                                    0,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      TopVideoCard(
                        title: "Property Video",
                        topDesigners: propertyDesigners,
                        onSeeAllTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllServicesScreen(
                                title: "Property Video",
                                skillId:
                                    skillProvider
                                        .propertyTopDesigner!
                                        .skill
                                        ?.id ??
                                    0,
                              ),
                            ),
                          );
                        },
                        isHome: true,
                      ),
                      SizedBox(height: 10.h),
                      TopServiceCard(
                        title: "Room Cleaning",
                        isDuck: true,
                        topDesigners: cleaningDesigners,
                        onSeeAllTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllServicesScreen(
                                title: "Room Cleaning",
                                skillId:
                                    skillProvider
                                        .cleaningTopDesigner!
                                        .skill
                                        ?.id ??
                                    0,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      TopServiceCard(
                        title: "Day To Duck",
                        topDesigners: dtdDesigners,
                        onSeeAllTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllServicesScreen(
                                title: "Day To Duck",
                                skillId:
                                    skillProvider.dtdTopDesigner!.skill?.id ??
                                    0,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      Footer(),
                    ],
                  ),
                ),
                if (skillProvider.isLoading)
                  Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.black.withOpacity(0.3),
                  ),
                if (skillProvider.isLoading)
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
                          CircularProgressIndicator(
                            color: AppColors.buttonGreen,
                          ),
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
            );
          },
        ),
      ),
    );
  }
}
