import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/service_model.dart';
import 'package:picpee_mobile/screens/photo-services/vendor_service_screen.dart';
import 'package:picpee_mobile/widgets/one_service_card.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  List<ServiceModel> services = List.generate(
    25,
    (index) => ServiceModel(
      title: "Top Designers In\nBlended Brackets\n(HDR)",
      beforeImageUrl:
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      afterImageUrl:
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
      rating: 5.0,
      reviewCount: 31,
      turnaroundTime: "12 hours",
      startingPrice: 0.75,
      designer: Designer(
        name: "Designer $index",
        avatarUrl:
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.5,
        completedOrders: 100 + index,
        isAutoAccepting: true,
      ),
    ),
  );

  int currentPage = 1;
  int perPage = 10;
  String filterOption = "All";

  List<ServiceModel> get paginatedServices {
    int start = (currentPage - 1) * perPage;
    int end = start + perPage;
    end = end > services.length ? services.length : end;
    return services.sublist(start, end);
  }

  int get totalPages => (services.length / perPage).ceil();

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
        });
      }
    });
  }

  // Helper method to build consistent filter items
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

  // Updated method to filter and sort services based on selected option
  List<ServiceModel> get filteredServices {
    List<ServiceModel> filtered = [...paginatedServices];

    // Apply sorting based on filter option
    switch (filterOption) {
      case "Release date":
        // Assuming newer services are at the end of the list, reverse to show newest first
        filtered.sort(
          (a, b) =>
              b.designer.completedOrders.compareTo(a.designer.completedOrders),
        );
        break;
      case "Featured":
        // Sort by rating and review count for "featured" items
        filtered.sort(
          (a, b) =>
              (b.rating * b.reviewCount).compareTo(a.rating * a.reviewCount),
        );
        break;
      case "Highest price":
        filtered.sort((a, b) => b.startingPrice.compareTo(a.startingPrice));
        break;
      case "Lowest price":
        filtered.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
        break;
      default:
        // Default "All" case, no special sorting
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    List<ServiceModel> displayedServices = filteredServices;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    final RenderBox button =
                        context.findRenderObject() as RenderBox;
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
                        color: AppColors.textGreen.withOpacity(0.5),
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
                          filterOption == "All" ? "Filter" : filterOption,
                          style: TextStyle(
                            fontSize: 14.h,
                            color: AppColors.textGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: displayedServices
                .map(
                  (service) => Container(
                    margin: EdgeInsets.only(
                      bottom: 10.h,
                      left: 16.h,
                      right: 16.h,
                    ),
                    child: OneServiceCard(
                      service: service,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorServiceScreen(),
                          ),
                        );
                      },
                      isDuck: false,
                    ),
                  ),
                )
                .toList(),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: currentPage > 1
                      ? const Color(0xFFF5F9F5)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 16.h,
                        color: currentPage > 1
                            ? const Color(0xFF2E7D32)
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
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
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.h,
                        color: currentPage < totalPages
                            ? const Color(0xFF2E7D32)
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
