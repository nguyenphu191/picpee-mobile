import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/service_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/widgets/before_after_card.dart';
import 'package:picpee_mobile/widgets/customer_drawer.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:picpee_mobile/widgets/header.dart';

class Service {
  final String name;
  final int count;
  final String category;

  Service({required this.name, required this.count, required this.category});
}

class Review {
  final String id;
  final String userName;
  final String? avatarUrl;
  final String content;
  final double rating;
  final int orderCount;
  final DateTime updatedOn;

  Review({
    required this.id,
    required this.userName,
    this.avatarUrl,
    required this.content,
    required this.rating,
    required this.orderCount,
    required this.updatedOn,
  });
}

class VendorServiceScreen extends StatefulWidget {
  @override
  _VendorServiceScreenState createState() => _VendorServiceScreenState();
}

class _VendorServiceScreenState extends State<VendorServiceScreen> {
  String selectedCategory = 'ALL';
  String selectedSortBy = 'Most Project';
  String selectedFilterBy = 'All stars';
  int displayedReviewsCount = 10;
  final int reviewsPerLoad = 10;

  final List<Service> services = [
    Service(name: 'ALL', count: 17, category: 'ALL'),
    Service(name: 'Image Enhancement', count: 4, category: 'Image Enhancement'),
    Service(name: 'Virtual Staging', count: 1, category: 'Virtual Staging'),
    Service(name: 'Day to dusk', count: 1, category: 'Day to dusk'),
    Service(name: 'Day to twilight', count: 1, category: 'Day to twilight'),
    Service(name: 'Object removal', count: 2, category: 'Object removal'),
    Service(name: 'Changing seasons', count: 1, category: 'Changing seasons'),
    Service(name: 'Water in pool', count: 1, category: 'Water in pool'),
    Service(name: 'Lawn replacement', count: 1, category: 'Lawn replacement'),
    Service(name: 'Rain to shine', count: 1, category: 'Rain to shine'),
    Service(
      name: 'Property videos services',
      count: 4,
      category: 'Property videos services',
    ),
  ];

  final List<ServiceModel> serviceItems = [
    ServiceModel(
      title: 'Single Exposure',
      subtitle: 'What\'s included?',
      startingPrice: 0.56,
      beforeImageUrl:
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      afterImageUrl:
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      capacity: 200,
      turnaroundTime: '12 hours',
      category: 'Image Enhancement',
      id: "1",
      rating: 5,
      reviewCount: 32,
      designer: Designer(
        name: "Designer 2",
        avatarUrl:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.7,
        completedOrders: 200,
        isAutoAccepting: true,
      ),
    ),
    ServiceModel(
      title: 'Blended Bracket',
      subtitle: 'What\'s included?',
      startingPrice: 0.75,
      beforeImageUrl:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      afterImageUrl:
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      capacity: 100,
      turnaroundTime: '12 hours',
      category: 'Image Enhancement',
      designer: Designer(
        name: "Designer 2",
        avatarUrl:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.7,
        completedOrders: 200,
        isAutoAccepting: true,
      ),
      rating: 3.5,
      reviewCount: 12,
      id: "2",
    ),
    ServiceModel(
      id: "3",
      title: 'Virtual Staging Premium',
      subtitle: 'What\'s included?',
      startingPrice: 2.50,
      beforeImageUrl:
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      afterImageUrl:
          'https://images.unsplash.com/photo-1505873242700-f289a29e1e0f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      capacity: 50,
      turnaroundTime: '24 hours',
      category: 'Virtual Staging',
      designer: Designer(
        name: "Designer 2",
        avatarUrl:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.7,
        completedOrders: 200,
        isAutoAccepting: true,
      ),
      rating: 4.8,
      reviewCount: 20,
    ),
    ServiceModel(
      id: "4",
      title: 'Day to Dusk Conversion',
      subtitle: 'What\'s included?',
      startingPrice: 1.25,
      beforeImageUrl:
          'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      afterImageUrl:
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      capacity: 75,
      turnaroundTime: '18 hours',
      category: 'Day to dusk',
      rating: 4.2,
      reviewCount: 15,
      designer: Designer(
        name: "Designer 2",
        avatarUrl:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80",
        rating: 4.7,
        completedOrders: 200,
        isAutoAccepting: true,
      ),
    ),
  ];

  final List<Review> allReviews = [
    Review(
      id: '1',
      userName: 'Romeo Alex',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      content:
          'I didn\'t expect you could do magic with my photo. It was so fun and satisfying! Thank you',
      rating: 5.0,
      orderCount: 53,
      updatedOn: DateTime(2025, 9, 4),
    ),
    Review(
      id: '2',
      userName: 'Angel Laurien',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108755-2616b612b647?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      content: 'Looks perfect.',
      rating: 5.0,
      orderCount: 27,
      updatedOn: DateTime(2025, 9, 9),
    ),
    Review(
      id: '3',
      userName: 'LJDong',
      avatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      content:
          'Outstanding work! I\'ll definitely recommend this editor to friends and colleagues.',
      rating: 5.0,
      orderCount: 26,
      updatedOn: DateTime(2025, 9, 8),
    ),
    Review(
      id: '4',
      userName: 'Sarah Johnson',
      content: 'Photos came out better than expected.',
      rating: 5.0,
      orderCount: 9,
      updatedOn: DateTime(2025, 9, 6),
    ),
    Review(
      id: '5',
      userName: 'James Brown',
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      content: 'Very satisfied, service was fast and high quality.',
      rating: 5.0,
      orderCount: 9,
      updatedOn: DateTime(2025, 9, 5),
    ),
    Review(
      id: '6',
      userName: 'AndersonBow',
      content:
          'I\'m so impressed with the edits I received! The lighting, colors, and overall tone of the photos make my house look warm and welcoming. They completely exceeded my expectations.',
      rating: 5.0,
      orderCount: 8,
      updatedOn: DateTime(2025, 9, 8),
    ),
    Review(
      id: '7',
      userName: 'Michael Chen',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      content: 'Great quality work and fast turnaround time. Will use again!',
      rating: 4.5,
      orderCount: 15,
      updatedOn: DateTime(2025, 9, 3),
    ),
    Review(
      id: '8',
      userName: 'Emma Wilson',
      content: 'Professional service with amazing results. Highly recommend!',
      rating: 5.0,
      orderCount: 22,
      updatedOn: DateTime(2025, 9, 2),
    ),
    Review(
      id: '9',
      userName: 'David Lee',
      avatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      content:
          'The editor transformed my photos beyond my expectations. Excellent work!',
      rating: 5.0,
      orderCount: 31,
      updatedOn: DateTime(2025, 9, 1),
    ),
    Review(
      id: '10',
      userName: 'Lisa Garcia',
      content:
          'Quick delivery and beautiful results. Very happy with the service.',
      rating: 4.8,
      orderCount: 18,
      updatedOn: DateTime(2025, 8, 30),
    ),
    Review(
      id: '11',
      userName: 'Robert Kim',
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      content:
          'Outstanding photo editing service. The results speak for themselves.',
      rating: 5.0,
      orderCount: 42,
      updatedOn: DateTime(2025, 8, 29),
    ),
    Review(
      id: '12',
      userName: 'Amanda Taylor',
      content: 'Professional and reliable. The photos look amazing!',
      rating: 4.9,
      orderCount: 35,
      updatedOn: DateTime(2025, 8, 28),
    ),
  ];

  List<ServiceModel> get filteredServiceItems {
    if (selectedCategory == 'ALL') {
      return serviceItems;
    }
    return serviceItems
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  List<Review> get filteredAndSortedReviews {
    List<Review> filtered = List.from(allReviews);

    // Apply filter
    if (selectedFilterBy != 'All stars') {
      double minRating = 0;
      switch (selectedFilterBy) {
        case '5 stars':
          minRating = 5.0;
          break;
        case '4+ stars':
          minRating = 4.0;
          break;
        case '3+ stars':
          minRating = 3.0;
          break;
      }
      filtered = filtered
          .where((review) => review.rating >= minRating)
          .toList();
    }

    // Apply sorting
    switch (selectedSortBy) {
      case 'Most Project':
        filtered.sort((a, b) => b.orderCount.compareTo(a.orderCount));
        break;
      case 'Latest':
        filtered.sort((a, b) => b.updatedOn.compareTo(a.updatedOn));
        break;
      case 'Highest Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  bool get hasMoreReviews =>
      displayedReviewsCount < filteredAndSortedReviews.length;

  void loadMoreReviews() {
    setState(() {
      displayedReviewsCount = (displayedReviewsCount + reviewsPerLoad).clamp(
        0,
        filteredAndSortedReviews.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomEndDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Vendor Info Section
                  Container(
                    color: const Color.fromARGB(239, 0, 0, 0),
                    padding: EdgeInsets.all(20.h),
                    child: Column(
                      children: [
                        SizedBox(height: 100.h),
                        Row(
                          children: [
                            Container(
                              width: 80.h,
                              height: 80.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'The Best Editor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 16.h,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '5 (32 reviews)',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'VN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Vietnam',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.buttonGreen,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                color: AppColors.buttonGreen,
                                size: 16.h,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Auto-accepting',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Chat button
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.MessageIcon,
                                width: 25.h,
                                height: 25.h,
                                color: Color(0xff2ABFD5),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Chat with Designer',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Services Filter
                        Container(
                          width: double.maxFinite,
                          constraints: BoxConstraints(
                            maxHeight: 258.h,
                            minHeight: 50.h,
                          ),
                          child: Wrap(
                            spacing: 8.h,
                            runSpacing: 8.h,
                            children: services.map((service) {
                              bool isSelected =
                                  selectedCategory == service.category;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = service.category;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.h,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.buttonGreen
                                          : Colors.grey[600]!,
                                      width: isSelected ? 2 : 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${service.name} ${service.count}',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[400],
                                      fontSize: 14.h,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 26.h),

                        // Stats row
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.h,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '33',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.h,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 16.h,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.h,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.grey[400],
                                      size: 16.h,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '32',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 16.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  // Handle share action
                                },

                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.h,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.buttonGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Start Order',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w600,
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

                  // Services List
                  Container(
                    padding: EdgeInsets.only(
                      top: 16.h,
                      bottom: 16.h,
                      left: 8.h,
                      right: 8.h,
                    ),
                    color: Colors.black,
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16),
                          itemCount: filteredServiceItems.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final item = filteredServiceItems[index];
                            return _buildServiceItem(item);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Reviews Section
                  _buildReviewsSection(),
                  //Footer
                  Footer(),
                ],
              ),
            ),
          ),
          Positioned(top: 16.h, left: 16.w, right: 16.w, child: Header()),
        ],
      ),
    );
  }

  Widget _buildServiceItem(ServiceModel item) {
    return Container(
      height: 380.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Service Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 75.h,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset(
                    AppImages.SingleExportIcon,
                    width: 40.h,
                    height: 40.h,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 20.h,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        InkWell(
                          onTap: () {
                            // Handle "What's included?" tap
                          },
                          child: Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 12.h,
                              color: AppColors.linkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${item.startingPrice.toString()}",
                        style: TextStyle(
                          fontSize: 16.h,
                          fontWeight: FontWeight.bold,
                          color: AppColors.linkBlue,
                        ),
                      ),
                      Text(
                        'per photo',
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
          ),

          // Before/After
          Positioned(
            top: 75.h,
            left: 0,
            right: 0,
            child: Container(
              height: 250.h,
              color: Colors.white,
              width: double.maxFinite,
              child: BeforeAfterCard(height: 200.h, width: 310.w),
            ),
          ),
          // Service Details
          Positioned(
            top: 260.h,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopNotchClipper(),
              child: Container(
                padding: EdgeInsets.all(16),
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border(top: BorderSide(color: Colors.black54)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Capacity',
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${item.capacity} per day',
                              style: TextStyle(
                                fontSize: 14.h,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Turnaround time',
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(16.h),
                                            child: Text(
                                              "Turnaround time is determined by the vendor. Turnaround time starts from the time the vendor accepts the order until the delivery. Modifications do not affect the turnaround time.",
                                              style: TextStyle(
                                                fontSize: 13.h,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 14.h,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.turnaroundTime,
                              style: TextStyle(
                                fontSize: 14.h,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Start Order',
                          style: TextStyle(
                            fontSize: 16.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final displayedReviews = filteredAndSortedReviews
        .take(displayedReviewsCount)
        .toList();

    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Reviews',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.h,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Filter Controls
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Sort By',
                  selectedSortBy,
                  ['Most Project', 'Latest', 'Highest Rating'],
                  (value) {
                    setState(() {
                      selectedSortBy = value;
                      displayedReviewsCount =
                          reviewsPerLoad; // Reset to initial count
                    });
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildDropdown(
                  'Filter by',
                  selectedFilterBy,
                  ['All stars', '5 stars', '4+ stars', '3+ stars'],
                  (value) {
                    setState(() {
                      selectedFilterBy = value;
                      displayedReviewsCount =
                          reviewsPerLoad; // Reset to initial count
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Reviews List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: displayedReviews.length,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              return _buildReviewItem(displayedReviews[index]);
            },
          ),

          // Load More Button
          if (hasMoreReviews) ...[
            SizedBox(height: 24.h),
            Center(
              child: Container(
                child: ElevatedButton(
                  onPressed: loadMoreReviews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Load more',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[600]!, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[400], fontSize: 12.h),
          ),
          SizedBox(height: 4.h),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: Colors.grey[800],
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.h,
              fontWeight: FontWeight.w500,
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 45.h,
                height: 45.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: review.avatarUrl == null ? Colors.green : null,
                  image: review.avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(review.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: review.avatarUrl == null
                    ? Center(
                        child: Text(
                          review.userName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),

              // User
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.h,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Updated on ${_formatDate(review.updatedOn)}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14.h),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Review Content
          Text(
            review.content,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14.h,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8.h),

          // Rating and Order Count
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: 18.h,
                    color: index < review.rating.floor()
                        ? Colors.orange
                        : Colors.grey[600],
                  );
                }),
              ),
              SizedBox(width: 8.w),
              Text(
                '(${review.orderCount} orders)',
                style: TextStyle(color: Colors.grey[400], fontSize: 14.h),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
