import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/screens/chat/chat_screen.dart';
import 'package:picpee_mobile/screens/discount/discount_screen.dart';
import 'package:picpee_mobile/screens/home/home_screen.dart';
import 'package:picpee_mobile/screens/profile/profile_screen.dart';
import 'package:picpee_mobile/screens/project/project_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, this.selectedIndex = 0});
  final int selectedIndex;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.75,
      child: SafeArea(
        child: Container(
          color: Colors.black87,
          child: Stack(
            children: [
              Positioned(
                top: 24.h,
                right: 16.w,
                left: 16.w,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomeScreen();
                              },
                            ),
                          );
                        },
                        child: Image.asset(
                          AppImages.logo1,
                          height: 56.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 55.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: widget.selectedIndex == 0
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.grey[700]!,
                                    Colors.grey[900]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              )
                            : null,
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.ProjectIcon,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Projects",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 55.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: widget.selectedIndex == 1
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.grey[700]!,
                                    Colors.grey[900]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              )
                            : null,
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.ProfileIcon,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscountScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 55.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: widget.selectedIndex == 2
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.grey[700]!,
                                    Colors.grey[900]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              )
                            : null,
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.DiscountIcon,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Discount",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen()),
                        );
                      },
                      child: Container(
                        height: 55.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: widget.selectedIndex == 3
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.grey[700]!,
                                    Colors.grey[900]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              )
                            : null,
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.MessageIcon,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Chat",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _launchURL('https://picpee.com/contact');
                      },
                      child: Container(
                        height: 55.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: widget.selectedIndex == 4
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.grey[700]!,
                                    Colors.grey[900]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              )
                            : null,
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.SupportIcon,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Support",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 210.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(AppImages.blance),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Wallet Balance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      const Text(
                        "\$ 0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        height: 48.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Topup",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Payment History",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
