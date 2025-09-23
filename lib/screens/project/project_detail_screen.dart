import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/core/utils/mock_order_data.dart';
import 'package:picpee_mobile/screens/project/project_widget/order_card.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key, required this.project})
    : super(key: key);

  final Project project;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _statusTabController;
  final TextEditingController _searchController = TextEditingController();

  Map<OrderStatus, int> get _statusCounts =>
      MockOrderData.getOrderCountByStatus();

  List<OrderStatus> get _availableStatuses {
    return OrderStatus.values
        .where((status) => _statusCounts[status]! > 0)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _statusTabController = TabController(
      length: _availableStatuses.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _statusTabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // Project Title and Add Button Section
                Container(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.project.name,
                              style: TextStyle(
                                fontSize: 20.h,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 36.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: AppColors.buttonGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 18.h,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Add new order',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Order Information / Design Information
                      Container(
                        child: TabBar(
                          controller: _mainTabController,
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
                          tabs: const [
                            Tab(text: 'Order Information'),
                            Tab(text: 'Design Information'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: TabBarView(
                    controller: _mainTabController,
                    children: [
                      Column(
                        children: [
                          // Search
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),

                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.h,
                                ),

                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.grey[500],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                              ),
                            ),
                          ),

                          // Status Tab Bar
                          Container(
                            height: 50.h,
                            child: TabBar(
                              controller: _statusTabController,
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
                              tabs: _availableStatuses.map((status) {
                                final count = _statusCounts[status] ?? 0;
                                return Tab(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${status.displayName} (${count})",
                                        style: TextStyle(fontSize: 14.h),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          // Order List
                          Expanded(
                            child: TabBarView(
                              controller: _statusTabController,
                              children: _availableStatuses.map((status) {
                                final orders = MockOrderData.getOrdersByStatus(
                                  status,
                                );
                                final filteredOrders =
                                    _searchController.text.isEmpty
                                    ? orders
                                    : orders.where((order) {
                                        return order.serviceName
                                                .toLowerCase()
                                                .contains(
                                                  _searchController.text
                                                      .toLowerCase(),
                                                ) ||
                                            order.id.toLowerCase().contains(
                                              _searchController.text
                                                  .toLowerCase(),
                                            );
                                      }).toList();

                                if (filteredOrders.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'No orders found',
                                          style: TextStyle(
                                            fontSize: 16.h,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.all(16.w),
                                  itemCount: filteredOrders.length,
                                  itemBuilder: (context, index) {
                                    return OrderCard(
                                      order: filteredOrders[index],
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      // Design
                      const Center(
                        child: Text(
                          'Design Information Content',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: "Project Details"),
          ),
        ],
      ),
    );
  }
}
