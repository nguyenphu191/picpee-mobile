import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/screens/home/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

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
                    onTap: () {},
                    child: Image.asset(
                      AppImages.InsIcon,
                      height: 42.sp,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5.h),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      AppImages.FbIcon,
                      height: 42.sp,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5.h),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      AppImages.TwtIcon,
                      height: 42.sp,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5.h),
                  InkWell(
                    onTap: () {},
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
                          onTap: () {
                            _launchURL('https://picpee.com/about-us');
                          },
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
                          onTap: () {
                            _launchURL('https://picpee.com/blogs');
                          },
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
                          onTap: () {
                            _launchURL('https://picpee.com/career');
                          },
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
                            _launchURL('https://www.picpee.com/how-it-works');
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
                          onTap: () {
                            _launchURL('https://picpee.com/help-center');
                          },
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
                          onTap: () {
                            _launchURL('https://picpee.com/contact');
                          },
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
                    onTap: () {
                      _launchURL('https://picpee.com/terms-of-service');
                    },
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
                    onTap: () {
                      _launchURL('https://picpee.com/privacy-policy');
                    },
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
                    onTap: () {
                      _launchURL('https://picpee.com/cookie-policy');
                    },
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
