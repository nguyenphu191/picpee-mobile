import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/providers/designer_provider.dart';
import 'package:picpee_mobile/screens/photo-services/portfolio_screen.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:provider/provider.dart';

class AllServicesBody extends StatefulWidget {
  const AllServicesBody({
    super.key,
    required this.title,
    required this.skillId,
  });
  final String title;
  final int skillId;

  @override
  State<AllServicesBody> createState() => _AllServicesBodyState();
}

class _AllServicesBodyState extends State<AllServicesBody> {
  int currentPage = 1;
  int perPage = 10;
  String filterOption = "All";

  // Show the filter popup
  void _showFilterOptions(BuildContext context, RenderBox button) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      items: [
        PopupMenuItem<String>(
          value: "All",
          child: _buildFilterItem("All", "All Services"),
        ),
        PopupMenuItem<String>(
          value: "Release date",
          child: _buildFilterItem("Release date", "Newest first"),
        ),
        PopupMenuItem<String>(
          value: "Featured",
          child: _buildFilterItem("Featured", "Most popular"),
        ),
        PopupMenuItem<String>(
          value: "Highest price",
          child: _buildFilterItem("Highest price", "Price high to low"),
        ),
        PopupMenuItem<String>(
          value: "Lowest price",
          child: _buildFilterItem("Lowest price", "Price low to high"),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          filterOption = value;
          currentPage = 1; // Reset về trang 1 khi thay đổi filter
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    print('Fetching data for page $currentPage with filter $filterOption');
    final designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    final res = await designerProvider.fetchAllVendorForSkill(widget.skillId);
    if (!res && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hàm sắp xếp danh sách designers theo filter
  List<DesignerModel> _getSortedDesigners(List<DesignerModel> designers) {
    List<DesignerModel> sortedList = List.from(designers);

    switch (filterOption) {
      case "Highest price":
        sortedList.sort((a, b) => b.cost.compareTo(a.cost));
        break;
      case "Lowest price":
        sortedList.sort((a, b) => a.cost.compareTo(b.cost));
        break;
      case "Featured":
        // Sắp xếp theo rating point (cao nhất trước)
        sortedList.sort((a, b) => b.ratingPoint.compareTo(a.ratingPoint));
        break;
      case "Release date":
        // Giả sử có trường createdAt hoặc id (id lớn hơn = mới hơn)
        // Nếu không có, bạn có thể bỏ qua hoặc thêm trường này vào model
        sortedList.sort((a, b) => b.userId.compareTo(a.userId));
        break;
      case "All":
      default:
        // Giữ nguyên thứ tự mặc định
        break;
    }

    return sortedList;
  }

  // Hàm lấy danh sách designers cho trang hiện tại
  List<DesignerModel> _getPaginatedDesigners(List<DesignerModel> designers) {
    final sortedDesigners = _getSortedDesigners(designers);
    final startIndex = (currentPage - 1) * perPage;
    final endIndex = startIndex + perPage;

    if (startIndex >= sortedDesigners.length) {
      return [];
    }

    return sortedDesigners.sublist(
      startIndex,
      endIndex > sortedDesigners.length ? sortedDesigners.length : endIndex,
    );
  }

  // Tính tổng số trang
  int _getTotalPages(int totalItems) {
    return (totalItems / perPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DesignerProvider>(
      builder: (context, designerProvider, child) {
        final topDesigners = designerProvider.allVendorsForSkill;
        final paginatedDesigners = _getPaginatedDesigners(topDesigners);
        final totalPages = _getTotalPages(topDesigners.length);

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: _fetchData,
              child: Container(
                height: size.height,
                width: size.width,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 190.h,
                        width: size.width,
                        padding: EdgeInsets.only(
                          top: 125.h,
                          left: 16.w,
                          right: 16.w,
                        ),
                        color: AppColors.brandDuck,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 24.h,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // TopServiceCard(title: widget.title, isHome: false),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.h,
                                vertical: 8.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      final RenderBox button =
                                          context.findRenderObject()
                                              as RenderBox;
                                      _showFilterOptions(context, button);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                        horizontal: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: AppColors.textGreen
                                              .withOpacity(0.5),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.filter_list,
                                            size: 18.h,
                                            color: AppColors.textGreen,
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            filterOption == "All"
                                                ? "Filter"
                                                : filterOption,
                                            style: TextStyle(
                                              fontSize: 14.h,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Hiển thị tổng số kết quả
                                  Text(
                                    '${topDesigners.length} results',
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Hiển thị danh sách designers đã phân trang
                            Column(
                              children: paginatedDesigners
                                  .map(
                                    (service) => Container(
                                      margin: EdgeInsets.only(
                                        bottom: 5.h,
                                        left: 10.h,
                                        right: 10.h,
                                      ),
                                      child: _buildServiceCard(service),
                                    ),
                                  )
                                  .toList(),
                            ),

                            // Pagination controls
                            if (totalPages > 1)
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Previous page button
                                    Material(
                                      color: currentPage > 1
                                          ? const Color(0xFFF5F9F5)
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(50),
                                      child: InkWell(
                                        onTap: currentPage > 1
                                            ? () =>
                                                  setState(() => currentPage--)
                                            : null,
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.h,
                                            vertical: 8.h,
                                          ),
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            size: 16.h,
                                            color: currentPage > 1
                                                ? const Color(0xFF2E7D32)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Current page indicator
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF4CAF50,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF4CAF50,
                                          ).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        "$currentPage / $totalPages",
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2E7D32),
                                        ),
                                      ),
                                    ),

                                    // Next page button
                                    Material(
                                      color: currentPage < totalPages
                                          ? const Color(0xFFF5F9F5)
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(50),
                                      child: InkWell(
                                        onTap: currentPage < totalPages
                                            ? () =>
                                                  setState(() => currentPage++)
                                            : null,
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.h,
                                            vertical: 8.h,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16.h,
                                            color: currentPage < totalPages
                                                ? const Color(0xFF2E7D32)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Footer(),
                    ],
                  ),
                ),
              ),
            ),
            if (designerProvider.isLoading)
              Container(color: Colors.black.withOpacity(0.3)),
            if (designerProvider.isLoading)
              Center(
                child: Container(
                  padding: EdgeInsets.all(20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.buttonGreen),
                      SizedBox(height: 8.h),
                      Text(
                        "Loading...",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFilterItem(String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 24.h,
          height: 24.h,
          decoration: BoxDecoration(
            color: filterOption == title
                ? AppColors.textGreen
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: filterOption == title ? AppColors.textGreen : Colors.grey,
              width: 1.5,
            ),
          ),
          child: filterOption == title
              ? Icon(Icons.check, color: Colors.white, size: 16.h)
              : null,
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.h,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12.h, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(DesignerModel service) {
    return Container(
      height: 98.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 1.5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PortfolioScreen(vendorId: service.userId),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 130.h,
              height: 98.h,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Image.network(service.imageSkill, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    service.businessName,
                    style: TextStyle(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.h),
                      SizedBox(width: 4.w),
                      Text(
                        '${service.ratingPoint} ',
                        style: TextStyle(
                          fontSize: 12.h,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '(${service.totalReview})',
                        style: TextStyle(
                          fontSize: 12.h,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.brandGreen,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: AppColors.buttonGreen,
                          size: 12.h,
                        ),
                        SizedBox(width: 3.h),
                        Text(
                          'Auto-accepting',
                          style: TextStyle(color: Colors.black, fontSize: 10.h),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    service.statusFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                  ),
                  onPressed: () async {
                    await Provider.of<DesignerProvider>(
                      context,
                      listen: false,
                    ).addFavoriteDesigner(service.userId, service.skillId);
                  },
                  iconSize: 18.h,
                  color: service.statusFavorite ? Colors.red : Colors.grey,
                ),
                Column(
                  children: [
                    Text(
                      "From",
                      style: TextStyle(fontSize: 12.h, color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${service.cost.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ],
            ),
            SizedBox(width: 5.w),
          ],
        ),
      ),
    );
  }
}
