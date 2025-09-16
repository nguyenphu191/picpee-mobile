import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/blog_model.dart';
import 'package:picpee_mobile/screens/blog/blog_detail_screen.dart';
import 'package:picpee_mobile/screens/blog/blogs_screen.dart';

class BlogDemoCard extends StatefulWidget {
  const BlogDemoCard({super.key});

  @override
  State<BlogDemoCard> createState() => _BlogDemoCardState();
}

class _BlogDemoCardState extends State<BlogDemoCard> {
  final List<BlogModel> blogs = [
    BlogModel(
      id: '1',
      title: 'Best Real Estate Photographers in Holliston',
      category: 'Real estate photography',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 15),
      imageUrl:
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '2',
      title: 'Best real estate photography in Calgary',
      category: 'Real estate photography',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 11),
      imageUrl:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '3',
      title: 'Best real estate photography in Brampton, ON',
      category: 'Real estate photography',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 11),
      imageUrl:
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '4',
      title: 'Professional Photography Tips for Real Estate',
      category: 'Photography tips',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 10),
      imageUrl:
          'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '5',
      title: 'Virtual Staging vs Traditional Staging',
      category: 'Virtual staging',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 9),
      imageUrl:
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '6',
      title: 'Day to Dusk Photography: Complete Guide',
      category: 'Photography tips',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 8),
      imageUrl:
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '7',
      title: 'Best Lighting Techniques for Interior Photography',
      category: 'Photography tips',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 7),
      imageUrl:
          'https://images.unsplash.com/photo-1505873242700-f289a29e1e0f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '8',
      title: 'HDR Photography for Real Estate',
      category: 'Photography tips',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 6),
      imageUrl:
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '9',
      title: 'Object Removal in Real Estate Photography',
      category: 'Photo editing',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 5),
      imageUrl:
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '10',
      title: 'Lawn Replacement and Seasonal Changes',
      category: 'Photo editing',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 4),
      imageUrl:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '11',
      title: 'Water Enhancement for Pool Photography',
      category: 'Photo editing',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 3),
      imageUrl:
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
    BlogModel(
      id: '12',
      title: 'Rain to Shine Photo Transformation',
      category: 'Photo editing',
      author: 'Admin',
      publishDate: DateTime(2025, 9, 2),
      imageUrl:
          'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(blogId: "1"),
          ),
        );
      },
      child: Container(
        height: 500.h,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                "Picpee Blogs",
                style: TextStyle(
                  fontSize: 24.h,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 300.h,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: PageView.builder(
                itemCount: blogs.length,
                controller: PageController(viewportFraction: 0.9),
                itemBuilder: (context, index) {
                  final item = blogs[index];
                  return _buildBlogItem(item, index);
                },
              ),
            ),
            SizedBox(height: 32.h),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogsScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.buttonGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'See More Blogs',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.h,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogItem(BlogModel item, int index) {
    return Stack(
      children: [
        Container(
          height: 300.h,
          width: double.infinity,
          margin: EdgeInsets.only(right: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 8.h,
          child: Container(
            height: 320.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          top: 180.h,
          left: 16.h,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    item.author,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: 280.w,
                  height: 52.h,
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 20.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 20.h,
                      color: Colors.grey[300],
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      item.publishDate.toIso8601String(),
                      style: TextStyle(fontSize: 14.h, color: Colors.grey[300]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
