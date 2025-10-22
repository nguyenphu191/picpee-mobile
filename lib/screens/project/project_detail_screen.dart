import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:picpee_mobile/screens/order/order_widget/add_order_card.dart';
import 'package:picpee_mobile/screens/project/project_widget/doer_card.dart';
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

  // 🔥 Hardcode Doer Data
  final List<DoerModel> _doers = [
    DoerModel(
      id: 1,
      name: 'John Smith',
      avatar: 'https://i.pravatar.cc/150?img=12',
      rated: false,
    ),
    DoerModel(
      id: 2,
      name: 'Emma Wilson',
      avatar: 'https://i.pravatar.cc/150?img=45',
      rated: true,
    ),
    DoerModel(
      id: 3,
      name: 'Michael Brown',
      avatar: 'https://i.pravatar.cc/150?img=33',
      rated: false,
    ),
    DoerModel(
      id: 4,
      name: 'Sarah Davis',
      avatar: 'https://i.pravatar.cc/150?img=47',
      rated: true,
    ),
    DoerModel(
      id: 5,
      name: 'David Lee',
      avatar: 'https://i.pravatar.cc/150?img=15',
      rated: false,
    ),
    DoerModel(
      id: 6,
      name: 'Lisa Anderson',
      avatar: 'https://i.pravatar.cc/150?img=48',
      rated: true,
    ),
    DoerModel(
      id: 7,
      name: 'James Taylor',
      avatar: 'https://i.pravatar.cc/150?img=51',
      rated: false,
    ),
    DoerModel(
      id: 8,
      name: 'Maria Garcia',
      avatar: 'https://i.pravatar.cc/150?img=44',
      rated: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(
      length: 3,
      vsync: this,
    ); // 🔥 Thay đổi length thành 3
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

  // 🔥 Handle Rate Button
  void _handleRate(DoerModel doer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text('Rate ${doer.name}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Would you like to rate this doer?'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(Icons.star, color: Colors.amber, size: 32);
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update rated status
              setState(() {
                final index = _doers.indexWhere((d) => d.id == doer.id);
                if (index != -1) {
                  _doers[index] = doer.copyWith(rated: true);
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thank you for rating ${doer.name}!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonGreen,
              foregroundColor: Colors.black,
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
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

                              if (availableStatuses.isEmpty || orders.isEmpty)
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Project has no orders yet.',
                                      style: TextStyle(
                                        fontSize: 16.h,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // Design Information Tab
                          _doers.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Designer found',
                                    style: TextStyle(
                                      fontSize: 16.h,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.all(16.w),
                                  itemCount: _doers.length,
                                  itemBuilder: (context, index) {
                                    final doer = _doers[index];
                                    return DoerCard(
                                      doer: doer,
                                      onRate: doer.rated
                                          ? null
                                          : () => _handleRate(doer),
                                    );
                                  },
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
