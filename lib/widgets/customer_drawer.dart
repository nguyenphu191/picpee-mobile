import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/user_model.dart';
import 'package:picpee_mobile/providers/user_provider.dart';
import 'package:picpee_mobile/screens/auth/login_screen.dart';
import 'package:picpee_mobile/screens/payment/payment_history.dart';
import 'package:picpee_mobile/screens/photo-services/all_top_service_screen.dart';
import 'package:picpee_mobile/screens/profile/profile_screen.dart';
import 'package:picpee_mobile/screens/payment/top_up.dart';
import 'package:picpee_mobile/screens/project/project_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:picpee_mobile/providers/auth_provider.dart';

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

  // Add logout function
  void _handleLogout() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Sign Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          },
        );

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout();

        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text('Signed out successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (error) {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8.w),
                  Expanded(child: Text('Sign out failed: ${error.toString()}')),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  String _formatPrice(double price) {
    if (price == price.toInt()) {
      return price.toInt().toString();
    }
    String fixed = price.toStringAsFixed(2);
    if (fixed.endsWith('0')) {
      return price.toStringAsFixed(1);
    }
    return fixed;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        User? user = userProvider.user;
        return Drawer(
          width: size.width * 0.8,
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.only(top: 40.h, left: 12.w, right: 10.w),
              children: [
                /// User info
                Row(
                  children: [
                    Container(
                      width: 56.r,
                      height: 56.r,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.buttonGreen,
                      ),
                      child: ClipOval(
                        child:
                            (user?.avatar != null && user!.avatar!.isNotEmpty)
                            ? Image.network(
                                user.avatar!.trim(),
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppImages.background1,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  (user?.businessName != null &&
                                          user!.businessName!.isNotEmpty)
                                      ? user.businessName!
                                            .substring(0, 1)
                                            .toUpperCase()
                                      : "U", // fallback nếu rỗng
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.businessName ?? "User Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.h,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: 180.w,
                          child: Text(
                            user?.email ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.h,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProjectsScreen()),
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
                    Navigator.pop(context);
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
                      Text(
                        "\$${_formatPrice(user?.balance ?? 0)}",
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
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => TopUpDialog(),
                            );
                          },
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
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentHistoryScreen(),
                              ),
                            );
                          },
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

                /// Sign out
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red, size: 24.h),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.red, fontSize: 16.h),
                  ),
                  onTap: _handleLogout, // Use the new logout function
                ),
                ListTile(
                  title: Text("Services", style: TextStyle(fontSize: 16.h)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllTopServiceScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  title: Text("Blogs", style: TextStyle(fontSize: 16.h)),
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL('https://picpee.com/blogs');
                  },
                ),
                ListTile(
                  title: Text("How it work", style: TextStyle(fontSize: 16.h)),
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL('https://picpee.com/how-it-works');
                  },
                ),
                ListTile(
                  title: Text("Contact", style: TextStyle(fontSize: 16.h)),
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL('https://picpee.com/contact');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
