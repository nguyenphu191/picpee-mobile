import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/blog_model.dart';
import 'package:picpee_mobile/screens/blog/blog_detail_screen.dart';
import 'package:picpee_mobile/widgets/customer_drawer.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:picpee_mobile/widgets/header.dart';

class BlogsScreen extends StatefulWidget {
  @override
  _BlogsScreenState createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  int displayedBlogsCount = 10;
  final int blogsPerLoad = 10;

  final List<BlogModel> allBlogs = [
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

  bool get hasMoreBlogs => displayedBlogsCount < allBlogs.length;

  void loadMoreBlogs() {
    setState(() {
      displayedBlogsCount = (displayedBlogsCount + blogsPerLoad).clamp(
        0,
        allBlogs.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedBlogs = allBlogs.take(displayedBlogsCount).toList();
    final featuredBlog = displayedBlogs.isNotEmpty
        ? displayedBlogs.first
        : null;
    final otherBlogs = displayedBlogs.length > 1
        ? displayedBlogs.skip(1).toList()
        : <BlogModel>[];

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.h,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 60.h),
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        'Picpee Blogs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Container(
                    color: Color(0xffFE8ECEF),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 36.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured Blog
                        if (featuredBlog != null) ...[
                          _buildFeaturedBlog(featuredBlog),
                          SizedBox(height: 40.h),
                        ],

                        // Latest Posts Section
                        Text(
                          'Latest Posts',
                          style: TextStyle(
                            fontSize: 24.h,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Blog Posts Grid
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: otherBlogs.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 20.h),
                          itemBuilder: (context, index) {
                            return _buildBlogCard(otherBlogs[index]);
                          },
                        ),

                        // Load More
                        if (hasMoreBlogs) ...[
                          SizedBox(height: 32.h),
                          Center(
                            child: Container(
                              width: 120.w,
                              child: ElevatedButton(
                                onPressed: loadMoreBlogs,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonGreen,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'Load More',
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

                        SizedBox(height: 26.h),
                      ],
                    ),
                  ),
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

  Widget _buildFeaturedBlog(BlogModel blog) {
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
        height: 390.h,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 250.h,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Image.network(
                    blog.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 210.h,
              left: 0,
              right: 30.w,
              child: Container(
                height: 180.h,
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff7C3AED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        blog.category,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      blog.title,
                      style: TextStyle(
                        fontSize: 20.h,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Container(
                          width: 36.h,
                          height: 36.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff4CAF50),
                          ),
                          child: Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          blog.author,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          _formatDate(blog.publishDate),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogCard(BlogModel blog) {
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
        height: 390.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220.h,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  blog.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              height: 170.h,
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff7C3AED).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      blog.category,
                      style: TextStyle(
                        color: Color(0xff7C3AED),
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Text(
                    blog.title,
                    style: TextStyle(
                      fontSize: 20.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Container(
                        width: 32.h,
                        height: 32.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff4CAF50),
                        ),
                        child: Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.h,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        blog.author,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        _formatDate(blog.publishDate),
                        style: TextStyle(
                          color: Colors.grey[600],
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
