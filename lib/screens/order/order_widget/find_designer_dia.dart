import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/service_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/screens/order/order_widget/designer_card.dart';

class FindDesigner extends StatefulWidget {
  const FindDesigner({super.key});

  @override
  State<FindDesigner> createState() => _FindDesignerState();
}

class _FindDesignerState extends State<FindDesigner> {
  static final List<ServiceModel> _hardcodedServices = [
    ServiceModel(
      title: "Top Designers In\nBlended Brackets\n(HDR)",
      beforeImageUrl:
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      afterImageUrl:
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
      rating: 5.0,
      reviewCount: 31,
      turnaroundTime: "12 hours",
      startingPrice: 0.75,
      designer: Designer(
        name: "Designer 1ssssssssssssssssss",
        avatarUrl:
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.5,
        completedOrders: 120,
        isAutoAccepting: true,
      ),
    ),
    ServiceModel(
      title: "Professional Photo\nRetouching\n(Premium)",
      beforeImageUrl:
          "https://images.unsplash.com/photo-1600298881974-6be191ceeda1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      afterImageUrl:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
      rating: 4.9,
      reviewCount: 127,
      turnaroundTime: "24 hours",
      startingPrice: 2.50,
      designer: Designer(
        name: "Designer 2asdfasasa",
        avatarUrl:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.7,
        completedOrders: 200,
        isAutoAccepting: true,
      ),
    ),
    ServiceModel(
      title: "AI-Enhanced\nPortrait Editing\n(Express)",
      beforeImageUrl:
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      afterImageUrl:
          "https://images.unsplash.com/photo-1494790108755-2616b612b605?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
      rating: 4.8,
      reviewCount: 89,
      turnaroundTime: "6 hours",
      startingPrice: 1.25,
      designer: Designer(
        name: "Designer 3",
        avatarUrl:
            "https://images.unsplash.com/photo-1494790108755-2616b612b605?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.6,
        completedOrders: 150,
        isAutoAccepting: true,
      ),
    ),
    ServiceModel(
      title: "AI-Enhanced\nPortrait Editing\n(Express)",
      beforeImageUrl:
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      afterImageUrl:
          "https://images.unsplash.com/photo-1494790108755-2616b612b605?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
      rating: 4.8,
      reviewCount: 89,
      turnaroundTime: "6 hours",
      startingPrice: 1.25,
      designer: Designer(
        name: "Designer 4",
        avatarUrl:
            "https://images.unsplash.com/photo-1494790108755-2616b612b605?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.6,
        completedOrders: 150,
        isAutoAccepting: true,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: size.height * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.background3),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 11, 121, 14),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16.w,
                      top: 16.h,
                      child: Text(
                        'Choose Designer',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonGreen,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16.h,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 24.h,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 20.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 52.h,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopNotchClipper(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  height: size.height * 0.8 - 52.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _hardcodedServices.length,
                          itemBuilder: (context, index) {
                            final service = _hardcodedServices[index];
                            return DesignerCard(
                              service: service,
                              onTap: () {
                                Navigator.pop(context, {
                                  'id': index.toString(),
                                  'name': service.designer.name,
                                  'avatarUrl': service.designer.avatarUrl,
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
