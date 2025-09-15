import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/screens/photo_services/service_widget/all_services_body.dart';
import 'package:picpee_mobile/widgets/customer_drawer.dart';
import 'package:picpee_mobile/widgets/header.dart';

class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({super.key, required this.title});
  final String title;

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  @override
  Widget build(BuildContext context) {
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
            child: AllServicesBody(title: widget.title),
          ),
          // Header
          Positioned(top: 16.h, left: 16.w, right: 16.w, child: Header()),
        ],
      ),
    );
  }
}
