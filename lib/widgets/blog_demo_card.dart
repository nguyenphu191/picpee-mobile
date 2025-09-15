import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogDemoCard extends StatefulWidget {
  const BlogDemoCard({super.key});

  @override
  State<BlogDemoCard> createState() => _BlogDemoCardState();
}

class _BlogDemoCardState extends State<BlogDemoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.h,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(color: Colors.blue),
      child: Column(
        children: [
          Container(
            height: 40.h,
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
        ],
      ),
    );
  }
}
