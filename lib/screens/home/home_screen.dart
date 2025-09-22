import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/screens/home/home_widget/home_body.dart';
import 'package:picpee_mobile/widgets/customer_drawer.dart';
import 'package:picpee_mobile/widgets/header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: const CustomEndDrawer(),
      body: Stack(
        children: [
          // Nội dung chính
          Positioned(top: 0, left: 0, right: 0, bottom: 0, child: HomeBody()),
          // Header
          Positioned(top: 16.h, left: 16.w, right: 16.w, child: Header()),
        ],
      ),
    );
  }
}
