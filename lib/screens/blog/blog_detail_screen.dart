import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/screens/blog/blog_widget/blog_data_table.dart';
import 'package:picpee_mobile/screens/blog/blog_widget/blog_list.dart';
import 'package:picpee_mobile/widgets/customer_drawer.dart';
import 'package:picpee_mobile/widgets/footer.dart';
import 'package:picpee_mobile/widgets/header.dart';

class BlogDetailScreen extends StatelessWidget {
  final String blogId;

  const BlogDetailScreen({Key? key, required this.blogId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomEndDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200.h,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 80.h),
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      'Detail Blog',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 36.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff7C3AED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Real estate photography',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      Text(
                        'Best real estate photography in Chapin, SC',
                        style: TextStyle(
                          fontSize: 24.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Blog image
                      Container(
                        height: 220.h,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      // Blog content
                      _buildBlogContent(context),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
                Footer(),
              ],
            ),
          ),

          // Header overlay
          Positioned(top: 16.h, left: 16.w, right: 16.w, child: Header()),
        ],
      ),
    );
  }

  Widget _buildBlogContent(BuildContext context) {
    final companiesData = [
      ['Company', 'Services', 'Price Range', 'Contact', 'Website', 'Reviews'],
      [
        'Chapin Photo Pro',
        'Interior, Exterior, Aerial',
        '\$150-300',
        '(803) 555-0123',
        'www.chapinphotopro.com',
        '★★★★☆ (45 reviews)',
      ],
      [
        'SC Real Estate Images',
        'HDR, Virtual Staging',
        '\$200-400',
        '(803) 555-0124',
        'www.screalestateimages.com',
        '★★★★★ (60 reviews)',
      ],
      [
        'Midlands Photography',
        'Drone, Twilight Shots',
        '\$175-350',
        '(803) 555-0125',
        'www.midlandsphotography.com',
        '★★★★☆ (30 reviews)',
      ],
      [
        'Capital City Shots',
        'Video Tours, 3D Tours',
        '\$250-500',
        '(803) 555-0126',
        'www.capitalcityshots.com',
        '★★★★★ (50 reviews)',
      ],
      [
        'Lexington Lens',
        'All Services',
        '\$180-380',
        '(803) 555-0127',
        'www.lexingtonlens.com',
        '★★★★☆ (40 reviews)',
      ],
    ];

    final benefitsData = [
      {
        'title': 'Connect with global experts:',
        'description':
            'Picpee allows you to easily find and work with real estate photo editing experts from all over the world, ensuring you always get the right person for your specific needs.',
      },
      {
        'title': 'Superior quality, competitive prices:',
        'description':
            'The platform is committed to delivering sharp, high-quality images at extremely reasonable prices. The image quality is always guaranteed to be consistent, helping you maintain a professional look on every listing.',
      },
      {
        'title': 'Fast processing speed:',
        'description':
            'With processing speed ranging from 12 to 24 hours, you can save time from photography to listing, helping you get your property to market faster.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The real estate market in Chapin, SC is booming, making the need for high-quality images a key factor in attracting potential buyers. Real estate photography in Chapin SC not only helps properties stand out online, but also helps shorten the time to sell and increase the value of the transaction. In this article, we will introduce the Top 5 real estate photography companies in Chapin, SC, along with detailed information about their services, prices, and contact information.',
          style: TextStyle(fontSize: 14.h, color: Colors.black87, height: 1.3),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 32.h),

        Text(
          'List of companies providing real estate photography services in Chapin, SC',
          style: TextStyle(
            fontSize: 18.h,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),

        BlogDataTable(
          data: companiesData,
          columnWidths: [3, 3, 3, 3, 3],
          maxHeight: 400.h,
          enableVerticalScroll: true,
        ),
        SizedBox(height: 32.h),

        Text(
          'When choosing a real estate photography service, consider factors such as portfolio quality, pricing, turnaround time, and additional services offered. It\'s also important to read reviews and testimonials from previous clients to ensure you\'re getting the best service. Search on Google Reviews, Facebook, or real estate forums. Honest feedback from real estate agents and homeowners will give you an objective view of the quality of service, work attitude, and professionalism of the company.',
          style: TextStyle(fontSize: 14.h, color: Colors.black87, height: 1.3),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 32.h),

        Text(
          'Picpee- The Best Real Estate Photo Editing Platform',
          style: TextStyle(
            fontSize: 18.h,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),

        Text(
          'In addition to hiring a local photographer in Chapin, SC, you have another effective solution to optimize your real estate images: use Picpee, the world\'s leading online real estate photo editing platform. It\'s the perfect choice to complement your photographer, or even as an alternative when you want more control over the post-production process.',
          style: TextStyle(fontSize: 14.h, color: Colors.black87, height: 1.3),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 24.h),

        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1460925895917-afdab827c52f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50.h,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 24.h),

        Text(
          'Why is Picpee an optimal choice?',
          style: TextStyle(
            fontSize: 16.h,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),

        BlogBulletList(
          items: benefitsData,
          titleKey: 'title',
          descriptionKey: 'description',
          bulletColor: Colors.black87,
          titleStyle: TextStyle(
            fontSize: 14.h,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
          descriptionStyle: TextStyle(
            fontSize: 14.h,
            color: Colors.black87,
            height: 1.3,
          ),
          spacing: 16.h,
        ),
      ],
    );
  }
}
