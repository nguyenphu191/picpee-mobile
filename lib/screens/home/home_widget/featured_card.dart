import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/models/skill_model.dart';
import 'package:picpee_mobile/screens/order/order_widget/add_order_card.dart';
import 'package:picpee_mobile/screens/photo-services/all_services_screen.dart';
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

  SkillModel get currentSkill {
    return widget.skillModels[_currentSkillIndex];
  }

  DesignerModel get currentDesigner {
    return currentSkill.topDesigners[_currentDesignerIndex];
  }

  void _previousSkill() {
    setState(() {
      _currentSkillIndex =
          (_currentSkillIndex - 1 + widget.skillModels.length) %
          widget.skillModels.length;
      _currentDesignerIndex = 0;
    });
  }

  void _nextSkill() {
    setState(() {
      _currentSkillIndex = (_currentSkillIndex + 1) % widget.skillModels.length;
      _currentDesignerIndex = 0;
    });
  }

  Color _getSkillBackgroundColor() {
    if (currentSkill.skill?.backgroudColor != null &&
        currentSkill.skill!.backgroudColor.isNotEmpty) {
      try {
        String colorStr = currentSkill.skill!.backgroudColor;
        if (colorStr.startsWith('#')) {
          colorStr = colorStr.substring(1);
        }
        if (colorStr.length == 6) {
          colorStr = 'FF$colorStr';
        }
        return Color(int.parse(colorStr, radix: 16));
      } catch (e) {
        return Colors.blue;
      }
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.skillModels.isEmpty || currentSkill.skill == null) {
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFEFF), Color(0xFFF4E9F5), Color(0xFFEEEFFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Featured Project',
                    style: TextStyle(
                      fontSize: 22.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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

          // Content section - Remove Expanded wrapper
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Add this
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
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: skillBackgroundColor,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: BeforeAfterCard(
                              key: ValueKey(
                                '${currentDesigner.userId}_${currentSkill.skill!.id}',
                              ),
                              designerId: currentDesigner.userId,
                              skillId: currentSkill.skill!.id,
                            ),
                          ),
                        ),

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
                                    color: Colors.white,
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
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: currentDesigner.avatar.isNotEmpty
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
                                                  size: 16.h,
                                                ),
                                                SizedBox(width: 2.w),
                                                Text(
                                                  '${currentDesigner.ratingPoint} (${currentDesigner.totalReview})',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.h,
                                                    fontWeight: FontWeight.bold,
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

                // Skill Description - Make it flexible
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Text(
                    currentSkill.skill?.description ??
                        'No description available.',
                    style: TextStyle(
                      fontSize: 14.h,
                      color: Colors.black,
                      height:
                          1.4, // Increased line height for better readability
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(height: 20.h),

                // Designers Section
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Text(
                    'Designers:',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w600,
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

                SizedBox(height: 16.h),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 42.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.h,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllServicesScreen(
                                skillId: currentSkill.skill!.id,
                                title: currentSkill.skill!.name,
                              ),
                            ),
                          );
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.h,
                        vertical: 4.h,
                      ),
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
                  ],
                ),

                SizedBox(height: 24.h), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignerAvatar(
    DesignerModel designer, {
    bool isSelected = false,
  }) {
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
