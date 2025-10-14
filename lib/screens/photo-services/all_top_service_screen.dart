import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/providers/skill_provider.dart';
import 'package:picpee_mobile/screens/photo-services/all_services_screen.dart';
import 'package:picpee_mobile/widgets/customer_drawer.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:picpee_mobile/widgets/header.dart';
import 'package:picpee_mobile/widgets/top_service_card.dart';
import 'package:provider/provider.dart';

class AllTopServiceScreen extends StatefulWidget {
  const AllTopServiceScreen({super.key});

  @override
  State<AllTopServiceScreen> createState() => _AllTopServiceScreenState();
}

class _AllTopServiceScreenState extends State<AllTopServiceScreen> {
  @override
  void initState() {
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
    return Consumer<SkillProvider>(
      builder: (context, skillProvider, child) {
        final skillModels = skillProvider.getHaveTopDesigners;
        return Scaffold(
          backgroundColor: Colors.black,
          endDrawer: const CustomEndDrawer(),
          body: Stack(
            children: [
              // Nội dung chính
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: RefreshIndicator(
                  onRefresh: _fetchTopDesigners,
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            height: 190.h,
                            width: size.width,
                            padding: EdgeInsets.only(
                              top: 125.h,
                              left: 16.w,
                              right: 16.w,
                            ),
                            color: AppColors.brandDuck,
                            child: Text(
                              "Services",
                              style: TextStyle(
                                fontSize: 24.h,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: size.width,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: skillModels.isEmpty
                                ? Container(
                                    height: 200.h,
                                    child: Center(
                                      child: Text(
                                        "No services available",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: skillModels
                                        .map(
                                          (skill) => TopServiceCard(
                                            title: skill.skill!.name,
                                            topDesigners: skill.topDesigners,
                                            onSeeAllTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllServicesScreen(
                                                        title:
                                                            skill.skill!.name,
                                                        skillId:
                                                            skill.skill!.id,
                                                      ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),
                          Footer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Header
              Positioned(top: 30.h, left: 16.w, right: 16.w, child: Header()),
              if (skillProvider.isLoading)
                Container(color: Colors.black.withOpacity(0.3)),
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
                        CircularProgressIndicator(color: AppColors.buttonGreen),
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
          ),
        );
      },
    );
  }
}
