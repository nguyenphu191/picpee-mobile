import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/screens/project/project_widget/one_project_card.dart';

class TrashCard extends StatefulWidget {
  const TrashCard({super.key, required this.deletedProjects, this.onRestore});
  final List<Project> deletedProjects;
  final void Function(Project)? onRestore;
  @override
  State<TrashCard> createState() => _TrashCardState();
}

class _TrashCardState extends State<TrashCard> {
  void _restoreProject(Project project) {
    setState(() {
      project.isDeleted = false;
    });
    widget.deletedProjects.remove(project);
  }

  void _permanentlyDeleteProject(Project project) {
    setState(() {
      widget.deletedProjects.remove(project);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.deletedProjects.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'The trash is empty.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.deletedProjects.length,
                  itemBuilder: (context, index) {
                    final project = widget.deletedProjects[index];
                    return OneProjectCard(
                      project: project,
                      menuItems: (context) => [
                        PopupMenuItem(
                          onTap: () => _restoreProject(project),
                          child: Row(
                            children: [
                              Icon(
                                Icons.restore,
                                color: Colors.grey[700],
                                size: 20.h,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Restore',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => _permanentlyDeleteProject(project),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_forever,
                                color: Colors.grey[700],
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete Forever',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
