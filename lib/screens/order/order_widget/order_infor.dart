import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/core/utils/mock_order_data.dart';

class OrderInfo extends StatefulWidget {
  final VoidCallback onCommentPressed;
  final VoidCallback onChecklistPressed;

  const OrderInfo({
    super.key,
    required this.onCommentPressed,
    required this.onChecklistPressed,
  });

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo>
    with SingleTickerProviderStateMixin {
  late TabController _fileTabController;
  final order = MockOrderData.getAllOrders()[8];
  final List<Map<String, dynamic>> mockActivities = [
    {'time': '2 hours ago', 'description': 'Order created by client'},
    {
      'time': '1 hour ago',
      'description': 'Designer John Doe submitted initial draft',
    },
    {
      'time': '30 minutes ago',
      'description': 'Client requested revision on color scheme',
    },
    {
      'time': '10 minutes ago',
      'description': 'Designer John Doe uploaded revised draft',
    },
  ];

  final List<Map<String, dynamic>> sourceFiles = [
    {'name': 'source_file_1.psd', 'size': '2.5 MB', 'icon': Icons.image},
    {
      'name': 'source_file_2.ai',
      'size': '1.8 MB',
      'icon': Icons.design_services,
    },
    {'name': 'source_file_3.sketch', 'size': '3.2 MB', 'icon': Icons.brush},
  ];

  final List<Map<String, dynamic>> finishedFiles = [
    {'name': 'final_design_1.png', 'size': '1.2 MB', 'icon': Icons.image},
    {'name': 'final_design_2.jpg', 'size': '0.8 MB', 'icon': Icons.image},
    {
      'name': 'final_design_3.pdf',
      'size': '0.5 MB',
      'icon': Icons.picture_as_pdf,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fileTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _fileTabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'comment':
        widget.onCommentPressed();
        break;
      case 'checklist':
        widget.onChecklistPressed();
        break;
      case 'edit':
        // Xử lý edit
        break;
      case 'delete':
        // Xử lý delete
        break;
      case 'completed':
        // Xử lý completed
        break;
      case 'revisions':
        // Xử lý revisions
        break;
      case 'dispute':
        // Xử lý dispute
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service info
          Row(
            children: [
              Image.asset(
                order.getServiceImg(),
                width: 40.h,
                height: 40.h,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 12.w),
              Text(
                order.serviceName,
                style: TextStyle(
                  fontSize: 18.h,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Status and menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: order.getStatusColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      order.getStatusIcon(),
                      color: order.getStatusColor(),
                      size: 18.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      order.status.displayName,
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.bold,
                        color: order.getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: _handleMenuSelection,
                offset: Offset(-30, 30),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.white,
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'comment',
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment,
                          size: 20.h,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Comment',
                          style: TextStyle(fontSize: 14.h, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'checklist',
                    child: Row(
                      children: [
                        Icon(
                          Icons.checklist,
                          size: 20.h,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Checklist',
                          style: TextStyle(fontSize: 14.h, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'completed',
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20.h,
                          color: Colors.green,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Mark Completed',
                          style: TextStyle(fontSize: 14.h, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'revisions',
                    child: Row(
                      children: [
                        Icon(Icons.restore, size: 20.h, color: Colors.orange),
                        SizedBox(width: 12.w),
                        Text(
                          'Request for Revisions',
                          style: TextStyle(fontSize: 14.h, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'dispute',
                    child: Row(
                      children: [
                        Icon(Icons.gavel, size: 20.h, color: Colors.red),
                        SizedBox(width: 12.w),
                        Text(
                          'Dispute Order',
                          style: TextStyle(fontSize: 14.h, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  size: 24.h,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Designer and total info
          Row(
            children: [
              Container(
                height: 56.h,
                width: 56.h,
                alignment: Alignment.center,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.buttonGreen,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: order.designerAvatar != ""
                    ? Image.network(order.designerAvatar, fit: BoxFit.cover)
                    : Text(
                        'N',
                        style: TextStyle(
                          fontSize: 24.h,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Designer',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${order.designerName}',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '\$${order.total}',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submitted',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    _formatDate(order.submitted),
                    style: TextStyle(
                      fontSize: 12.h,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due Date',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    _formatDate(order.dueDate),
                    style: TextStyle(
                      fontSize: 12.h,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Activity section
          Text(
            'Activity',
            style: TextStyle(
              fontSize: 14.h,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Divider(),
          Container(
            constraints: BoxConstraints(maxHeight: 200.h),
            child: ListView.builder(
              itemCount: mockActivities.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final activity = mockActivities[index];
                return Container(
                  padding: EdgeInsets.only(bottom: 12.h, left: 8.w, right: 8.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8.h,
                        height: 8.h,
                        margin: EdgeInsets.only(top: 6.h, right: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity['description'],
                              style: TextStyle(
                                fontSize: 14.h,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              activity['time'],
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),

          // Files TabBar
          Container(
            child: TabBar(
              controller: _fileTabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
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
                Tab(text: "Source Files"),
                Tab(text: "Finished Files"),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Files content
          Container(
            height: 200.h,
            child: TabBarView(
              controller: _fileTabController,
              children: [
                _buildFileList(sourceFiles),
                _buildFileList(finishedFiles),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildFileList(List<Map<String, dynamic>> files) {
    return Column(
      children: files
          .map(
            (file) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              child: Row(
                children: [
                  Icon(Icons.image, color: Colors.red, size: 24.h),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      file['name'],
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
