import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/screens/order/order_widget/checklist_side.dart';
import 'package:picpee_mobile/screens/order/order_widget/comment_side.dart';
import 'package:picpee_mobile/screens/order/order_widget/order_infor.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  late TabController _drawerTabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _drawerTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _drawerTabController.dispose();
    super.dispose();
  }

  // Functions to open drawer tabs
  void _openCommentTab() {
    _drawerTabController.animateTo(0);
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _openChecklistTab() {
    _drawerTabController.animateTo(1);
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: _buildEndDrawer(),
      drawer: const SideBar(selectedIndex: 0),
      body: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: OrderInfo(
              onCommentPressed: _openCommentTab,
              onChecklistPressed: _openChecklistTab,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: "Overview"),
          ),
        ],
      ),
    );
  }

  Widget _buildEndDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 40.h,
              left: 16.w,
              right: 16.w,
              bottom: 8.h,
            ),
            child: TabBar(
              controller: _drawerTabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 14.h,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.h,
                fontWeight: FontWeight.w600,
              ),
              onTap: (index) => setState(() {}),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text("Comments")],
                  ),
                ),
                Tab(text: "Checklist"),
              ],
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _drawerTabController,
              children: [
                // Comments Tab
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CommentSide(),
                ),
                // Checklist Tab
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ChecklistSide(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
