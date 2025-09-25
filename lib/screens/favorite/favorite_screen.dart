import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/order_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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
    // Add more items as needed
  ];

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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView.builder(
          itemCount: favoriteItems.length,
          itemBuilder: (context, index) {
            final item = favoriteItems[index];
            return _buildItemCard(item);
          },
        ),
      ),
    );
  }

  _buildItemCard(Map<String, dynamic> item) {
    return Container(
      height: 118.h,
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
          // Service Image
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
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
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
          SizedBox(width: 8.w),

          // Service and Editor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  item['service']['name'],
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            item['editor']['name'],
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.star, size: 14.h, color: Colors.amber),
                              SizedBox(width: 4.w),
                              Text(
                                '${item['editor']['rating']} (${item['editor']['reviews']} reviews)',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
