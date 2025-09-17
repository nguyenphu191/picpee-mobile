import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/screens/project/project_widget/one_project_card.dart';

class ProjectListCard extends StatefulWidget {
  const ProjectListCard({super.key, required this.activeProjects});
  final List<Project> activeProjects;
  @override
  State<ProjectListCard> createState() => _ProjectListCardState();
}

class _ProjectListCardState extends State<ProjectListCard> {
  void _deleteProject(Project project) {
    setState(() {
      project.isDeleted = true;
    });
    widget.activeProjects.remove(project);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activeProjects.isEmpty) {
      return const Center(
        child: Text(
          'No projects yet',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.activeProjects.length,
      itemBuilder: (context, index) {
        final project = widget.activeProjects[index];
        return OneProjectCard(
          project: project,
          menuItems: (context) => [
            PopupMenuItem(
              onTap: () {},
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.grey[700], size: 20.h),
                  SizedBox(width: 8),
                  Text(
                    'Rename Project',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.h),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => _deleteProject(project),
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.grey[700], size: 20.h),
                  SizedBox(width: 8),
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
