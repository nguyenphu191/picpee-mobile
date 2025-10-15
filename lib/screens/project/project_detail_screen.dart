import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:picpee_mobile/screens/order/order_widget/add_order_card.dart';
import 'package:picpee_mobile/screens/project/project_widget/order_card.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';
import 'package:provider/provider.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key, required this.project})
    : super(key: key);

  final ProjectModel project;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  TabController? _statusTabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrders();
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _statusTabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchOrders() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final succes = await orderProvider.fetchOrders(widget.project.id);
    if (!succes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load orders'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final orders = orderProvider.orders;
        final availableStatuses = orders
            .map((order) => order.getStatusText())
            .toSet()
            .toList();

        // Khởi tạo hoặc cập nhật TabController khi có dữ liệu
        if (availableStatuses.isNotEmpty) {
          if (_statusTabController == null ||
              _statusTabController!.length != availableStatuses.length) {
            _statusTabController?.dispose();
            _statusTabController = TabController(
              length: availableStatuses.length,
              vsync: this,
            );
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          drawer: const SideBar(selectedIndex: 0),
          body: Stack(
            children: [
              Positioned(
                top: 80.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddOrderCard(),
                        );
                      },
                      child: Container(
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
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
                                indicatorColor: Colors.black,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                labelStyle: TextStyle(
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w600,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontSize: 16.h,
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
                                    suffixIcon:
                                        _searchController.text.isNotEmpty
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
                              if (availableStatuses.isNotEmpty &&
                                  _statusTabController != null)
                                Container(
                                  child: TabBar(
                                    controller: _statusTabController,
                                    tabAlignment: TabAlignment.start,
                                    isScrollable: true,
                                    indicatorColor: Colors.black,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.grey,
                                    labelStyle: TextStyle(
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    unselectedLabelStyle: TextStyle(
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    onTap: (index) => setState(() {}),
                                    tabs: availableStatuses.map((status) {
                                      return Tab(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              status,
                                              style: TextStyle(fontSize: 16.h),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),

                              // Order List
                              if (availableStatuses.isNotEmpty &&
                                  _statusTabController != null)
                                Expanded(
                                  child: TabBarView(
                                    controller: _statusTabController,
                                    children: availableStatuses.map((status) {
                                      final statusOrders = orderProvider.orders
                                          .where(
                                            (order) =>
                                                order.getStatusText() == status,
                                          )
                                          .toList();
                                      final filteredOrders =
                                          _searchController.text.isEmpty
                                          ? statusOrders
                                          : statusOrders.where((order) {
                                              return order.skill!.name
                                                  .toLowerCase()
                                                  .contains(
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

                              // Loading/Empty state khi chưa có dữ liệu
                              if (availableStatuses.isEmpty)
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 16.h),
                                        Text(
                                          'Loading orders...',
                                          style: TextStyle(
                                            fontSize: 16.h,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // Design
                          const Center(
                            child: Text(
                              'Design Information Content',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
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
      },
    );
  }
}
