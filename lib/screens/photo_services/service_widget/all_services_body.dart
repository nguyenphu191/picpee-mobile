import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/screens/photo_services/service_widget/services_list.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:picpee_mobile/widgets/top_service_card.dart';

class AllServicesBody extends StatefulWidget {
  const AllServicesBody({super.key, required this.title});
  final String title;

  @override
  State<AllServicesBody> createState() => _AllServicesBodyState();
}

class _AllServicesBodyState extends State<AllServicesBody> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.cyan,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220.h,
              width: size.width,
              padding: EdgeInsets.only(top: 120.h, left: 16.h, right: 16.h),
              color: AppColors.brandDuck,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 28.h, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            TopServiceCard(title: widget.title, isHome: false),
            ServiceListPage(),
            Footer(),
          ],
        ),
      ),
    );
  }
}
