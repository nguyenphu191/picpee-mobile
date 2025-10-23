import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/review_model.dart';
import 'package:picpee_mobile/screens/project/project_widget/add_review_card.dart';

class DoerCard extends StatefulWidget {
  const DoerCard({super.key, required this.doer});
  final Reviewer doer;

  @override
  State<DoerCard> createState() => _DoerCardState();
}

class _DoerCardState extends State<DoerCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.buttonGreen,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                widget.doer.avatar.trim(),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doer.businessName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Rate Button or Rated Status
          if (!widget.doer.rated)
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black54,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AddReviewCard(isEditing: false, vendor: widget.doer);
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonGreen,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: Text(
                'Rate',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            )
          else
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black54,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AddReviewCard(isEditing: true, vendor: widget.doer);
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green[300]!, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16.sp,
                      color: Colors.green[700],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Rated',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
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

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.person, size: 30.sp, color: Colors.grey[600]),
      ),
    );
  }
}
