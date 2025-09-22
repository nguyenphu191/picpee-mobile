import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Future<void> _launchURL(String url, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url);

      // Kiểm tra xem có thể launch URL không
      bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Mở trong browser external
        );
      } else {
        // Hiển thị thông báo lỗi nếu không thể mở
        _showErrorSnackBar(context, 'Cannot open this link');
      }
    } catch (e) {
      print('Error launching URL: $e');
      _showErrorSnackBar(context, 'Failed to open link');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: 450.h,
          width: size.width,
          padding: EdgeInsets.all(25.h),
          decoration: BoxDecoration(color: AppColors.brandDuck),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(AppImages.logo1, height: 52.sp),
              ),
              SizedBox(height: 10.h),
              Container(
                child: Text(
                  "We're Growing Up Your Business with Stunning Real Estate Photography!",
                  style: TextStyle(
                    fontSize: 20.h,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  InkWell(
                    onTap: () =>
                        _launchURL('https://www.instagram.com/picpee', context),
                    child: Image.asset(
                      AppImages.InsIcon,
                      height: 42.sp,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5.h),
                  InkWell(
                    onTap: () =>
                        _launchURL('https://www.facebook.com/picpee', context),
                    child: Image.asset(
                      AppImages.FbIcon,
                      height: 42.sp,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5.h),
                  InkWell(
                    onTap: () =>
                        _launchURL('https://twitter.com/picpee', context),
                    child: Image.asset(
                      AppImages.TwtIcon,
                      height: 42.sp,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5.h),
                  InkWell(
                    onTap: () =>
                        _launchURL('https://github.com/picpee', context),
                    child: Image.asset(
                      AppImages.GitIcon,
                      height: 42.sp,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5.h),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                height: 170.h,
                padding: EdgeInsets.all(16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () =>
                              _launchURL('https://picpee.com/about', context),
                          child: Text(
                            "About Us",
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _launchURL(
                            'https://picpee.com/services',
                            context,
                          ),
                          child: Text(
                            "Services",
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              _launchURL('https://picpee.com/news', context),
                          child: Text(
                            "News",
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              _launchURL('https://picpee.com/careers', context),
                          child: Text(
                            "Careers",
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            _launchURL(
                              'https://picpee.com/how-it-works',
                              context,
                            );
                          },
                          child: Text(
                            "How it work",
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              _launchURL('https://picpee.com/help', context),
                          child: Text(
                            "Help Center",
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              _launchURL('https://picpee.com/contact', context),
                          child: Text(
                            "Contact",
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 56.h,
          width: double.infinity,
          color: AppColors.buttonGreen,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 26.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '© 2025 Picpee Inc. All rights reserved.',
                style: TextStyle(
                  fontSize: 14.h,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () =>
                        _launchURL('https://picpee.com/terms', context),
                    child: Text(
                      "Terms of Service",
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        _launchURL('https://picpee.com/privacy', context),
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        _launchURL('https://picpee.com/cookies', context),
                    child: Text(
                      "Cookies",
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
