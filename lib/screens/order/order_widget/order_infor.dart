import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:picpee_mobile/screens/order/order_widget/dispute_card.dart';
import 'package:picpee_mobile/screens/order/order_widget/revision_card.dart';
import 'package:picpee_mobile/services/ggdrive_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderInfo extends StatefulWidget {
  final VoidCallback onCommentPressed;
  final VoidCallback onChecklistPressed;
  final OrderModel order;
  const OrderInfo({
    super.key,
    required this.onCommentPressed,
    required this.onChecklistPressed,
    required this.order,
  });

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo>
    with SingleTickerProviderStateMixin {
  late TabController _fileTabController;
  List<DriveFile> _sourceFiles = [];
  List<DriveFile> _deliverableFiles = [];
  bool _isLoadingSource = false;
  bool _isLoadingDeliverable = false;

  @override
  void initState() {
    super.initState();
    _fileTabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFiles();
      fetchActivitys();
    });
  }

  @override
  void dispose() {
    _fileTabController.dispose();
    super.dispose();
  }

  Future<void> _loadFiles() async {
    // Load source files
    if (widget.order.sourceFilesLink != null &&
        widget.order.sourceFilesLink!.isNotEmpty) {
      setState(() => _isLoadingSource = true);
      try {
        final files = await GoogleDriveService.getFilesFromFolder(
          widget.order.sourceFilesLink!,
        );
        setState(() {
          _sourceFiles = files;
          _isLoadingSource = false;
        });
        print('Loaded ${files.length} source files');
      } catch (e) {
        setState(() => _isLoadingSource = false);
        print('Error loading source files: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load source files: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    // Load deliverable files
    if (widget.order.deliverableFilesLink != null &&
        widget.order.deliverableFilesLink.isNotEmpty) {
      setState(() => _isLoadingDeliverable = true);
      try {
        final files = await GoogleDriveService.getFilesFromFolder(
          widget.order.deliverableFilesLink!,
        );
        setState(() {
          _deliverableFiles = files;
          _isLoadingDeliverable = false;
        });
        print('Loaded ${files.length} deliverable files');
      } catch (e) {
        setState(() => _isLoadingDeliverable = false);
        print('Error loading deliverable files: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to load deliverable files: ${e.toString()}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _openFile(DriveFile file) async {
    if (file.webViewLink != null) {
      final uri = Uri.parse(file.webViewLink!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Cannot open file')));
        }
      }
    }
  }

  Future<void> _openDriveFolder(String? folderUrl) async {
    if (folderUrl == null || folderUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Folder link not available'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      final uri = Uri.parse(folderUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot open folder link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid folder link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> fetchActivitys() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final succes = await orderProvider.fetchOrderActivities(widget.order.id);
    if (!succes) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load order activities'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
      case 'completed':
        completedOrder();
        break;
      case 'revisions':
        showDialog(
          context: context,
          barrierColor: Colors.black54,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return RevisionCard(order: widget.order);
          },
        );
        break;
      case 'dispute':
        showDialog(
          context: context,
          barrierColor: Colors.black54,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return DisputeCard(order: widget.order);
          },
        );
        break;
    }
  }

  String _formatPrice(double price) {
    if (price == price.toInt()) {
      return price.toInt().toString();
    }
    String fixed = price.toStringAsFixed(2);
    if (fixed.endsWith('0')) {
      return price.toStringAsFixed(1);
    }
    return fixed;
  }

  Future<void> completedOrder() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.completeOrder(widget.order.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order marked as completed'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to complete order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final activitys = orderProvider.activities;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service info
              Row(
                children: [
                  Image.network(
                    widget.order.skill!.urlImage.trim(),
                    width: 40.h,
                    height: 40.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.buttonGreen,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40.h,
                        height: 40.h,
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Icon(Icons.broken_image, size: 20.h),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    widget.order.skill!.name,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: widget.order.getStatusColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.order.getStatusIcon(),
                          color: widget.order.getStatusColor(),
                          size: 18.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          widget.order.getStatusText(),
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.bold,
                            color: widget.order.getStatusColor(),
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
                              style: TextStyle(
                                fontSize: 14.h,
                                color: Colors.black,
                              ),
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
                              style: TextStyle(
                                fontSize: 14.h,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.order.status == 'DELIVERED') ...[
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
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'revisions',
                          child: Row(
                            children: [
                              Icon(
                                Icons.restore,
                                size: 20.h,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Request for Revisions',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (widget.order.status == 'In_PROGRESS' ||
                          widget.order.status == 'DELIVERED' ||
                          widget.order.status == 'PENDING_VENDOR_CONFIRM')
                        PopupMenuItem<String>(
                          value: 'dispute',
                          child: Row(
                            children: [
                              Icon(Icons.gavel, size: 20.h, color: Colors.red),
                              SizedBox(width: 12.w),
                              Text(
                                'Dispute Order',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.red,
                                ),
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
                    decoration: BoxDecoration(
                      color: AppColors.buttonGreen,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        widget.order.vendor!.avatar?.trim() ??
                            'https://placeholder.com/avatar.png',
                        width: 56.h,
                        height: 56.h,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.buttonGreen,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: Icon(Icons.person, size: 24.h),
                          );
                        },
                      ),
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
                          '${widget.order.vendor!.businessName}',
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
                        '\$${_formatPrice(widget.order.cost)}',
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
              SizedBox(height: 12.h),

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
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        widget.order.createdTime,
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
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
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        widget.order.dueTime,
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Activity section - IMPROVED UI
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timeline,
                            size: 20.h,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Activity',
                            style: TextStyle(
                              fontSize: 14.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    activitys.isEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Center(
                              child: Text(
                                'No activities yet',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(maxHeight: 220.h),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: activitys.length,
                              separatorBuilder: (context, index) =>
                                  Padding(padding: EdgeInsets.only(left: 30.w)),
                              itemBuilder: (context, index) {
                                final activity = activitys[index];
                                final isLast = index == activitys.length - 1;

                                return Container(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 15.h,
                                            height: 15.h,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.blue[300]!,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.circle,
                                              size: 6.h,
                                              color: Colors.blue[600],
                                            ),
                                          ),
                                          if (!isLast)
                                            Container(
                                              width: 2,
                                              height: 20.h,
                                              color: Colors.grey[300],
                                            ),
                                        ],
                                      ),
                                      SizedBox(width: 10.w),
                                      // Activity content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              activity.title,
                                              style: TextStyle(
                                                fontSize: 14.h,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                                height: 1.4,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 12.h,
                                                  color: Colors.grey[600],
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  activity.createdTime,
                                                  style: TextStyle(
                                                    fontSize: 12.h,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
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
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // Files TabBar
              Container(
                child: TabBar(
                  controller: _fileTabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
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
                    Tab(text: "Source Files (${_sourceFiles.length})"),
                    Tab(text: "Finished Files (${_deliverableFiles.length})"),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              _buildLinkButton(),
              SizedBox(height: 16.h),
              // Files content
              Container(
                height: 300.h,
                child: TabBarView(
                  controller: _fileTabController,
                  children: [
                    _buildFileList(_sourceFiles, _isLoadingSource),
                    _buildFileList(_deliverableFiles, _isLoadingDeliverable),
                  ],
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLinkButton() {
    // Determine which link to show based on current tab
    final isSourceTab = _fileTabController.index == 0;
    final linkUrl = isSourceTab
        ? widget.order.sourceFilesLink
        : widget.order.deliverableFilesLink;
    final linkLabel = isSourceTab ? 'Source Files' : 'Finished Files';

    if (linkUrl == null || linkUrl.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _openDriveFolder(linkUrl),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          side: BorderSide(color: Colors.black54, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(Icons.folder_open, color: Colors.black, size: 20.h),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                'Open $linkLabel in Google Drive',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(List<DriveFile> files, bool isLoading) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12.h),
            Text(
              'Loading files from Google Drive...',
              style: TextStyle(fontSize: 14.h, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 48.h, color: Colors.grey[400]),
            SizedBox(height: 8.h),
            Text(
              'No files available',
              style: TextStyle(fontSize: 14.h, color: Colors.grey[600]),
            ),
            SizedBox(height: 4.h),
            Text(
              'Files will appear here once uploaded',
              style: TextStyle(fontSize: 12.h, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: files.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final file = files[index];
        return InkWell(
          onTap: () => _openFile(file),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(file.icon, color: file.iconColor, size: 32.h),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            file.formattedSize,
                            style: TextStyle(
                              fontSize: 12.h,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (file.modifiedTime != null) ...[
                            Text(
                              ' • ',
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _formatDate(file.modifiedTime!),
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.open_in_new, size: 20.h, color: Colors.grey[600]),
              ],
            ),
          ),
        );
      },
    );
  }
}
