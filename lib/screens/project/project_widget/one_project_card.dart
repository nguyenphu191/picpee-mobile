import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/screens/project/project_detail_screen.dart';

class OneProjectCard extends StatelessWidget {
  final ProjectModel project;
  final List<PopupMenuEntry<dynamic>> Function(BuildContext) menuItems;

  const OneProjectCard({
    super.key,
    required this.project,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailScreen(project: project),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.25), width: 1),
        ),
        child: Row(
          children: [
            // Project Icon
            Container(
              width: 48.h,
              height: 48.h,
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                AppImages.FolderIcon,
                fit: BoxFit.cover,
                color: Colors.deepPurpleAccent,
              ),
            ),
            SizedBox(width: 12.w),

            // Project Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Name
                  Text(
                    project.name,
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),

                  // Last Order Time
                  if (project.lastOrderTime.isNotEmpty)
                    Text(
                      'Last ordered: ${project.lastOrderTime}',
                      style: TextStyle(
                        fontSize: 12.h,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // Skills
                  if (project.skillNames.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      project.skillNames,
                      style: TextStyle(
                        fontSize: 12.h,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Menu Button
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.grey[600], size: 20.h),
              itemBuilder: menuItems,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              offset: Offset(-10, 0),
            ),
          ],
        ),
      ),
    );
  }
}
