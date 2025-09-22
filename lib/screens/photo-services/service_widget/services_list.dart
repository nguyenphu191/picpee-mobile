import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    30,
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

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("All"),
              onTap: () {
                setState(() {
                  filterOption = "All";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Price < 10"),
              onTap: () {
                setState(() {
                  filterOption = "Price < 10";
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ServiceModel> displayedServices = paginatedServices;
    if (filterOption == "Price < 10") {
      displayedServices = displayedServices
          .where((s) => s.reviewCount < 10)
          .toList();
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _showFilterOptions();
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 80.h,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.h),
                margin: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemCount: displayedServices.length,
              itemBuilder: (context, index) {
                final service = displayedServices[index];
                return Container(
                  height: 370.h,
                  width: 320.w,
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
                );
              },
            ),
          ),
          SizedBox(height: 5.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: currentPage > 1
                    ? () => setState(() => currentPage--)
                    : null,
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 18.h,
                  color: const Color.fromARGB(255, 11, 83, 6),
                ),
              ),
              SizedBox(width: 8.w), // Khoảng cách giữa nút và số trang
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),

                child: Text(
                  "$currentPage / $totalPages",
                  style: TextStyle(
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 11, 83, 6),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => setState(() => currentPage++)
                    : null,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 18.h,
                  color: const Color.fromARGB(255, 11, 83, 6),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
