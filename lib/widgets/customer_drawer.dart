import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/screens/auth/login_screen.dart';
import 'package:picpee_mobile/screens/profile/profile_screen.dart';
import 'package:picpee_mobile/screens/project/project_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomEndDrawer extends StatefulWidget {
  const CustomEndDrawer({super.key});

  @override
  State<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends State<CustomEndDrawer> {
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
      width: size.width * 0.8,
      child: SafeArea(
        child: Container(
          // margin: EdgeInsets.only(top: 16.h, bottom: 16.h),
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              /// User info
              Row(
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundImage: AssetImage(
                      AppImages.background1,
                    ), // ảnh user
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "J.M.Designs",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.h,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "t9561510@gmail.com",
                        style: TextStyle(color: Colors.grey, fontSize: 13.h),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(height: 24.h),

              ListTile(
                leading: Image.asset(
                  AppImages.DrawerProfile,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(color: Colors.black, fontSize: 16.h),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: Image.asset(
                  AppImages.DrawerOrder,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Orders",
                  style: TextStyle(color: Colors.black, fontSize: 16.h),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreen(
                        project: Project(
                          id: '1',
                          name: 'FakeReview',
                          lastOrdered: DateTime.parse('2025-08-09 05:17:00'),
                          description: 'Orders: 360° Image Enhancement,...',
                          iconColor: Colors.purple,
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Image.asset(
                  AppImages.DrawerSupport,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Support Center",
                  style: TextStyle(color: Colors.black, fontSize: 16.h),
                ),
                onTap: () {
                  _launchURL('https://picpee.com/contact');
                },
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 16.h),
                padding: EdgeInsets.all(16.w),
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
                        fontSize: 20,
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
                          style: TextStyle(color: Colors.white, fontSize: 16.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Sign out
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red, size: 24.h),
                title: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.red, fontSize: 16.h),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),

              /// Bottom links
              ListTile(
                title: Text("Services", style: TextStyle(fontSize: 16.h)),
                onTap: () {},
              ),
              ListTile(
                title: Text("Blogs", style: TextStyle(fontSize: 16.h)),
                onTap: () {
                  _launchURL('https://picpee.com/blogs');
                },
              ),
              ListTile(
                title: Text("How it work", style: TextStyle(fontSize: 16.h)),
                onTap: () {
                  _launchURL('https://picpee.com/how-it-works');
                },
              ),
              ListTile(
                title: Text("Contact", style: TextStyle(fontSize: 16.h)),
                onTap: () {
                  _launchURL('https://picpee.com/contact');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
