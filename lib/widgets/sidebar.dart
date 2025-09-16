import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/screens/profile/profile_screen.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.75,
      child: SafeArea(
        child: Container(
          color: Colors.black87,
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Image.asset(AppImages.logo1, height: 52.h),
              ),
              SizedBox(height: 24.h),

              ListTile(
                leading: Image.asset(
                  AppImages.ProjectIcon,
                  height: 24.h,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Projects",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
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
                  AppImages.ProfileIcon,
                  height: 24.h,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Image.asset(
                  AppImages.DiscountIcon,
                  height: 24.h,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Discount",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Image.asset(
                  AppImages.SupportIcon,
                  height: 24.h,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Support Center",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {},
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
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
                onTap: () {},
              ),

              /// Bottom links
              ListTile(
                title: Text("Services", style: TextStyle(fontSize: 16.h)),
                onTap: () {},
              ),
              ListTile(
                title: Text("Blogs", style: TextStyle(fontSize: 16.h)),
                onTap: () {},
              ),
              ListTile(
                title: Text("How it work", style: TextStyle(fontSize: 16.h)),
                onTap: () {},
              ),
              ListTile(
                title: Text("Contact", style: TextStyle(fontSize: 16.h)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
