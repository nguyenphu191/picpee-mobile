import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/widgets/before_after_card.dart';

class FeaturedCard extends StatefulWidget {
  const FeaturedCard({Key? key}) : super(key: key);

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  int _currentDesignerIndex = 0;

  final List<Map<String, dynamic>> designers = [
    {
      'name': 'S.M.Designs',
      'color': Colors.brown,
      'service': 'Single Exposure',
      'description':
          'Convert a single exposure or pre-blended exposure into a professional, realistic image. Adjust color, contrast, and lighting for a polished, flawless finish.',
    },
    {
      'name': 'BluePixel Studio',
      'color': Colors.blue,
      'service': 'HDR Processing',
      'description':
          'Enhance your images with HDR techniques to achieve vibrant colors and balanced lighting for stunning, high-quality results.',
    },
    {
      'name': 'GreenFrame Creations',
      'color': Colors.green,
      'service': 'Virtual Staging',
      'description':
          'Transform empty spaces with virtual furniture and decor to create inviting, realistic scenes for real estate or design projects.',
    },
    {
      'name': 'OrangeLight Designs',
      'color': Colors.orange,
      'service': 'Photo Retouching',
      'description':
          'Refine your photos with precise retouching, enhancing details and removing imperfections for a professional look.',
    },
  ];

  void _previousDesigner() {
    setState(() {
      _currentDesignerIndex =
          (_currentDesignerIndex - 1 + designers.length) % designers.length;
    });
  }

  void _nextDesigner() {
    setState(() {
      _currentDesignerIndex = (_currentDesignerIndex + 1) % designers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDesigner = designers[_currentDesignerIndex];

    return Container(
      height: 770.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFEFF), Color(0xFFF4E9F5), Color(0xFFEEEFFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Project',
                  style: TextStyle(
                    fontSize: 24.h,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: _previousDesigner,
                      child: Container(
                        height: 36.h,
                        width: 36.h,
                        padding: EdgeInsets.only(left: 4.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 16.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      onTap: _nextDesigner,
                      child: Container(
                        height: 36.h,
                        width: 36.h,
                        padding: EdgeInsets.only(left: 4.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 16.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                children: [
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Background Image
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: currentDesigner['color'],
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: BeforeAfterCard(),
                            ),
                          ),

                          // Edit by section
                          Positioned(
                            bottom: 16.h,
                            left: 16.h,
                            right: 16.h,
                            child: IgnorePointer(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      'Edit by',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14.h,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      Container(
                                        width: 36.h,
                                        height: 36.h,
                                        decoration: BoxDecoration(
                                          color: currentDesigner['color'],
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 16.h,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8.h),
                                      Text(
                                        currentDesigner['name'],
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w600,
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
                  ),

                  SizedBox(height: 24.h),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 24.h,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          currentDesigner['service'],
                          style: TextStyle(
                            fontSize: 18.h,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Text(
                      currentDesigner['description'],
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Text(
                      'Designers:',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Row(
                      children: designers.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> designer = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentDesignerIndex = index;
                            });
                          },
                          child: _buildDesignerAvatar(
                            designer['color'],
                            isSelected: index == _currentDesignerIndex,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 180.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View More Projects',
                            style: TextStyle(
                              fontSize: 16.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 120.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: AppColors.buttonGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Start Order',
                            style: TextStyle(
                              fontSize: 16.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Bottom indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignerAvatar(Color color, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.black : Colors.white,
          width: isSelected ? 3 : 2,
        ),
      ),
      child: const Icon(Icons.person, size: 20, color: Colors.white),
    );
  }
}
