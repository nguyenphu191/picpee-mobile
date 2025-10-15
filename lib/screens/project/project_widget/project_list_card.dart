import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/screens/project/project_widget/one_project_card.dart';

class ProjectListCard extends StatefulWidget {
  final List<ProjectModel> activeProjects;
  final Function(ProjectModel)? onEdit;
  final Function(ProjectModel)? onMoveToTrash;

  const ProjectListCard({
    super.key,
    required this.activeProjects,
    this.onEdit,
    this.onMoveToTrash,
  });

  @override
  State<ProjectListCard> createState() => _ProjectListCardState();
}

class _ProjectListCardState extends State<ProjectListCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.activeProjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64.h, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No projects found',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.h,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Create your first project to get started',
              style: TextStyle(color: Colors.grey[600], fontSize: 14.h),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: widget.activeProjects.length,
      itemBuilder: (context, index) {
        final project = widget.activeProjects[index];
        return OneProjectCard(
          project: project,
          menuItems: (context) => [
            PopupMenuItem(
              onTap: () {
                // Use Future.delayed to avoid calling during build
                Future.delayed(Duration.zero, () {
                  widget.onEdit?.call(project);
                });
              },
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.grey[700], size: 20.h),
                  SizedBox(width: 8.w),
                  Text(
                    'Rename Project',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.h),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () {
                // Use Future.delayed to avoid calling during build
                Future.delayed(Duration.zero, () {
                  widget.onMoveToTrash?.call(project);
                });
              },
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.grey[700], size: 20.h),
                  SizedBox(width: 8.w),
                  Text(
                    'Move to Trash',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.h),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
