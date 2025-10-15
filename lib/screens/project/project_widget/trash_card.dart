import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/screens/project/project_widget/one_project_card.dart';

class TrashCard extends StatefulWidget {
  final List<ProjectModel> deletedProjects;
  final Function(ProjectModel)? onRestore;
  final Function(ProjectModel)? onPermanentDelete;

  const TrashCard({
    super.key,
    required this.deletedProjects,
    this.onRestore,
    this.onPermanentDelete,
  });

  @override
  State<TrashCard> createState() => _TrashCardState();
}

class _TrashCardState extends State<TrashCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.deletedProjects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 64.h,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'The trash is empty.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Deleted projects will appear here',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.h,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: widget.deletedProjects.length,
                  itemBuilder: (context, index) {
                    final project = widget.deletedProjects[index];
                    return OneProjectCard(
                      project: project,
                      menuItems: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            // Use Future.delayed to avoid calling during build
                            Future.delayed(Duration.zero, () {
                              widget.onRestore?.call(project);
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.restore,
                                color: Colors.green[700],
                                size: 20.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Restore',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            // Use Future.delayed to avoid calling during build
                            Future.delayed(Duration.zero, () {
                              widget.onPermanentDelete?.call(project);
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_forever,
                                color: Colors.red[700],
                                size: 20.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Delete Forever',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w500,
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
