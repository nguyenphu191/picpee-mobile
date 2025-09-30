import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Add search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> favoriteItems = [
    {
      'editor': {
        'id': 1,
        'name': 'Alice Johnson',
        'rating': 4.8,
        'reviews': 120,
        'avatarUrl':
            'https://static1.cbrimages.com/wordpress/wp-content/uploads/2022/11/avatar-the-way-of-water-poster.jpg',
      },
      'service': {
        'id': 1,
        'name': 'Photo Editing',
        'imageUrl':
            'https://static1.cbrimages.com/wordpress/wp-content/uploads/2022/11/avatar-the-way-of-water-poster.jpg',
      },
    },
    {
      'editor': {
        'id': 2,
        'name': 'Bob Smith',
        'rating': 4.5,
        'reviews': 85,
        'avatarUrl':
            'https://tse2.mm.bing.net/th/id/OIP.gRsMK8djOPccYsCUVi2fYAHaDt?pid=Api&h=220&P=0',
      },
      'service': {
        'id': 2,
        'name': 'Video Editing',
        'imageUrl':
            'https://tse2.mm.bing.net/th/id/OIP.gRsMK8djOPccYsCUVi2fYAHaDt?pid=Api&h=220&P=0',
      },
    },
    {
      'editor': {
        'id': 2,
        'name': 'Bob Smith',
        'rating': 4.5,
        'reviews': 85,
        'avatarUrl':
            'https://tse2.mm.bing.net/th/id/OIP.gRsMK8djOPccYsCUVi2fYAHaDt?pid=Api&h=220&P=0',
      },
      'service': {
        'id': 2,
        'name': 'Video Editing',
        'imageUrl':
            'https://tse2.mm.bing.net/th/id/OIP.gRsMK8djOPccYsCUVi2fYAHaDt?pid=Api&h=220&P=0',
      },
    },
  ];

  @override
  void initState() {
    super.initState();
    // Add listener to update search query when text changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    // Clean up controller
    _searchController.dispose();
    super.dispose();
  }

  // Filter items based on search query
  List<Map<String, dynamic>> get filteredItems {
    if (_searchQuery.isEmpty) {
      return favoriteItems;
    }
    return favoriteItems.where((item) {
      final serviceName = item['service']['name'].toString().toLowerCase();
      final editorName = item['editor']['name'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return serviceName.contains(query) || editorName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.h,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: EdgeInsets.only(
              top: 12.h,
              left: 12.w,
              right: 12.w,
              bottom: 8.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search favorites...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 1.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),

          // Results count when searching
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filteredItems.length} results found',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12.h),
                ),
              ),
            ),

          // List of favorites
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64.h,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No favorites found',
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _buildItemCard(item);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  _buildItemCard(Map<String, dynamic> item) {
    return Container(
      height: 108.h,
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Image.network(
                  item['service']['imageUrl'],
                  width: 136.w,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 5.h,
                left: 5.h,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      favoriteItems.remove(item);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 28.h,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        size: 20.h,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 5.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Text(
                  item['service']['name'],
                  style: TextStyle(
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20.h,
                      backgroundImage: NetworkImage(
                        item['editor']['avatarUrl'],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            item['editor']['name'],
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.star, size: 14.h, color: Colors.amber),
                              SizedBox(width: 4.w),
                              Text(
                                '${item['editor']['rating']} ',
                                style: TextStyle(
                                  fontSize: 12.h,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(${item['editor']['reviews']} reviews)',
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
                SizedBox(height: 5.h),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.brandGreen, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: AppColors.textGreen, size: 14.h),
                      SizedBox(width: 3.h),
                      Text(
                        'Auto-accepting',
                        style: TextStyle(
                          color: AppColors.textGreen,
                          fontSize: 12.h,
                        ),
                      ),
                    ],
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
