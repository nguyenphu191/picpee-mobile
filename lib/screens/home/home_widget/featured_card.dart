import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/skill_model.dart';
import 'package:picpee_mobile/screens/order/order_widget/add_order_card.dart';
import 'package:picpee_mobile/widgets/before_after_card.dart';

class FeaturedCard extends StatefulWidget {
  const FeaturedCard({super.key, required this.skillModels});
  final List<SkillModel> skillModels;

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  int _currentSkillIndex = 0;
  int _currentDesignerIndex = 0;

  // Get current skill
  SkillModel get currentSkill {
    if (widget.skillModels.isEmpty) return _getEmptySkillModel();
    return widget.skillModels[_currentSkillIndex];
  }

  // Get current designer
  TopDesigner get currentDesigner {
    if (currentSkill.topDesigners.isEmpty) return _getEmptyTopDesigner();
    return currentSkill.topDesigners[_currentDesignerIndex];
  }

  // Navigate to previous skill
  void _previousSkill() {
    setState(() {
      _currentSkillIndex =
          (_currentSkillIndex - 1 + widget.skillModels.length) %
          widget.skillModels.length;
      _currentDesignerIndex = 0; // Reset designer index when changing skill
    });
  }

  // Navigate to next skill
  void _nextSkill() {
    setState(() {
      _currentSkillIndex = (_currentSkillIndex + 1) % widget.skillModels.length;
      _currentDesignerIndex = 0; // Reset designer index when changing skill
    });
  }

  // Navigate to previous designer within current skill
  void _previousDesigner() {
    if (currentSkill.topDesigners.isEmpty) return;
    setState(() {
      _currentDesignerIndex =
          (_currentDesignerIndex - 1 + currentSkill.topDesigners.length) %
          currentSkill.topDesigners.length;
    });
  }

  // Navigate to next designer within current skill
  void _nextDesigner() {
    if (currentSkill.topDesigners.isEmpty) return;
    setState(() {
      _currentDesignerIndex =
          (_currentDesignerIndex + 1) % currentSkill.topDesigners.length;
    });
  }

  // Fallback empty skill model
  SkillModel _getEmptySkillModel() {
    return SkillModel(
      skill: Skill(
        id: 0,
        category: 'General',
        name: 'No Skills Available',
        costDefault: 0.0,
        turnaroundTimeDefault: 0,
        performanceDefault: 0,
        limitNumberImage: 0,
        maxNumberImage: 0,
        description: 'No skills available at the moment.',
        type: '',
        typeUpload: '',
        status: '',
        orderNo: 0,
        urlImage: '',
        alias: '',
        isShowHome: false,
        backgroudColor: '#ffffff',
        classCard: 0,
        skillAddOnsRes: [],
      ),
      topDesigners: [],
    );
  }

  // Fallback empty designer
  TopDesigner _getEmptyTopDesigner() {
    return TopDesigner(
      userId: 0,
      code: '',
      lastname: 'No',
      firstname: 'Designer',
      businessName: 'No Designer Available',
      avatar: '',
      countryCode: '',
      statusUser: '',
      statusReceiveOrder: 'NOT_ACCEPTING',
      imageFlag: '',
      imageCover:
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      skillId: 0,
      skillName: '',
      category: '',
      turnaroundTime: 0,
      cost: 0.0,
      imageSkill: '',
      ratingPoint: 0.0,
      totalReview: 0,
      userSkillId: 0,
      totalFavorite: 0,
      statusFavorite: false,
      verified: false,
    );
  }

  // Get background color from skill
  Color _getSkillBackgroundColor() {
    if (currentSkill.skill?.backgroudColor != null &&
        currentSkill.skill!.backgroudColor.isNotEmpty) {
      try {
        String colorStr = currentSkill.skill!.backgroudColor;
        if (colorStr.startsWith('#')) {
          colorStr = colorStr.substring(1);
        }
        if (colorStr.length == 6) {
          colorStr = 'FF$colorStr'; // Add alpha if missing
        }
        return Color(int.parse(colorStr, radix: 16));
      } catch (e) {
        return Colors.blue; // Fallback color
      }
    }
    return Colors.blue; // Default color
  }

  @override
  Widget build(BuildContext context) {
    if (widget.skillModels.isEmpty) {
      return Container(
        height: 400.h,
        child: Center(
          child: Text(
            'No featured projects available',
            style: TextStyle(fontSize: 16.h, color: Colors.grey),
          ),
        ),
      );
    }

    final skillBackgroundColor = _getSkillBackgroundColor();

    return Container(
      height: 750.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFEFF), Color(0xFFF4E9F5), Color(0xFFEEEFFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Header with skill navigation
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Featured Project',
                        style: TextStyle(
                          fontSize: 22.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (currentSkill.skill != null)
                        Text(
                          currentSkill.skill!.name,
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: _previousSkill,
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
                      onTap: _nextSkill,
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
                  // Before/After Image Container
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
                          // Background Image with Designer Navigation
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: skillBackgroundColor,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: CustomBeforeAfterSlider(
                                beforeImage:
                                    currentDesigner.imageCover.isNotEmpty
                                    ? currentDesigner.imageCover
                                    : 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
                                afterImage:
                                    currentDesigner.imageCover.isNotEmpty
                                    ? currentDesigner.imageCover
                                    : 'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=800&q=80',
                                height: 300.h,
                                width: 500.w,
                              ),
                            ),
                          ),

                          // Before/After Labels
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Before',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 12.h,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.h,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                'After',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 12.h,
                                ),
                              ),
                            ),
                          ),

                          // Designer navigation arrows
                          if (currentSkill.topDesigners.length > 1) ...[
                            Positioned(
                              left: 0.h,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: GestureDetector(
                                  onTap: _previousDesigner,
                                  child: Container(
                                    padding: EdgeInsets.all(8.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: 24.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: GestureDetector(
                                  onTap: _nextDesigner,
                                  child: Container(
                                    padding: EdgeInsets.all(8.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 24.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          // Designer info overlay
                          Positioned(
                            bottom: 16.h,
                            left: 16.h,
                            right: 16.h,
                            child: IgnorePointer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Edit by',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      // Designer Avatar
                                      Container(
                                        width: 36.h,
                                        height: 36.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child:
                                              currentDesigner.avatar.isNotEmpty
                                              ? Image.network(
                                                  currentDesigner.avatar,
                                                  width: 36.h,
                                                  height: 36.h,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (
                                                        context,
                                                        child,
                                                        loadingProgress,
                                                      ) {
                                                        if (loadingProgress ==
                                                            null)
                                                          return child;
                                                        return Container(
                                                          color:
                                                              skillBackgroundColor,
                                                          child: Center(
                                                            child: SizedBox(
                                                              width: 16.w,
                                                              height: 16.h,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                      Color
                                                                    >(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color:
                                                              skillBackgroundColor,
                                                          child: Icon(
                                                            Icons.person,
                                                            size: 16.h,
                                                            color: Colors.white,
                                                          ),
                                                        );
                                                      },
                                                )
                                              : Container(
                                                  color: skillBackgroundColor,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 16.h,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 8.h),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentDesigner.businessName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.h,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (currentDesigner.ratingPoint > 0)
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 12.h,
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  Text(
                                                    '${currentDesigner.ratingPoint} (${currentDesigner.totalReview})',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 12.h,
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
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Skill Information
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
                        Expanded(
                          child: Text(
                            currentSkill.skill?.name ?? 'Unknown Service',
                            style: TextStyle(
                              fontSize: 18.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Skill Description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Text(
                      currentSkill.skill?.description ??
                          'No description available.',
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Designers Section
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Text(
                      'Designers (${currentSkill.topDesigners.length}):',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Designer Avatars
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: currentSkill.topDesigners.map((designer) {
                          bool isSelected =
                              designer.userId == currentDesigner.userId;
                          return GestureDetector(
                            onTap: () {
                              int index = currentSkill.topDesigners.indexOf(
                                designer,
                              );
                              if (index != -1) {
                                setState(() {
                                  _currentDesignerIndex = index;
                                });
                              }
                            },
                            child: _buildDesignerAvatar(
                              designer,
                              isSelected: isSelected,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Action Buttons
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 42.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Navigate to projects list
                        },
                        child: Text(
                          'View More Projects',
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 4.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 120.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: AppColors.buttonGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AddOrderCard();
                              },
                            );
                          },
                          child: Text(
                            'Start Order',
                            style: TextStyle(
                              fontSize: 14.h,
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

  Widget _buildDesignerAvatar(TopDesigner designer, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 5.h),
      width: 40.h,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.buttonGreen : Colors.white,
          width: isSelected ? 2 : 2,
        ),
      ),
      child: ClipOval(
        child: designer.avatar.isNotEmpty
            ? Image.network(
                designer.avatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey[600]!,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: _getSkillBackgroundColor(),
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.white,
                    ),
                  );
                },
              )
            : Container(
                color: _getSkillBackgroundColor(),
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
      ),
    );
  }
}
