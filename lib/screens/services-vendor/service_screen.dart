import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/core/utils/service_hard_data.dart';
import 'package:picpee_mobile/screens/services-vendor/service_detail_screen.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<ServiceItem> services = servicesData;
  final TextEditingController _searchController = TextEditingController();

  // Group services by category
  Map<String, List<ServiceItem>> get groupedServices {
    Map<String, List<ServiceItem>> grouped = {};
    for (var service in services) {
      if (!grouped.containsKey(service.category)) {
        grouped[service.category] = [];
      }
      grouped[service.category]!.add(service);
    }
    return grouped;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      drawer: const SideBar(selectedIndex: 5),
      body: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        // Preview
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 16.w,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.visibility_outlined, size: 20.h),
                                SizedBox(width: 8.w),
                                Text(
                                  'Preview on Marketplace',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),
                        Divider(),
                        SizedBox(height: 8.h),

                        // Verify
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Text(
                                'Verify your skill',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.h,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '17/28 verified',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Services List
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...groupedServices.entries.map((entry) {
                            String categoryName = entry.key;
                            List<ServiceItem> categoryServices = entry.value;

                            return _buildCategoryTile(
                              categoryName,
                              categoryServices,
                            );
                          }).toList(),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: "Services Overview"),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(
    String categoryName,
    List<ServiceItem> categoryServices,
  ) {
    return Container(
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),

        title: Row(
          children: [
            Expanded(
              child: Text(
                categoryName,
                style: TextStyle(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        iconColor: const Color(0xFF666666),
        children: categoryServices
            .map(
              (service) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ServiceDetailScreen(service: service),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 8.h,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.title,
                        style: TextStyle(
                          fontSize: 16.h,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      if (service.title == "Single Exposure") ...[
                        SizedBox(width: 8.w),
                        Image.asset(
                          AppImages.VerifiedIcon,
                          height: 20.h,
                          width: 20.h,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
