import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/screens/project/project_widget/create_new_project.dart';
import 'package:picpee_mobile/screens/project/project_widget/project_list_card.dart';
import 'package:picpee_mobile/screens/project/project_widget/trash_card.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Project> projects = [
    Project(
      id: '1',
      name: 'FakeReview',
      lastOrdered: DateTime.parse('2025-08-09 05:17:00'),
      description: 'Orders: 360° Image Enhancement,...',
      iconColor: Colors.purple,
    ),
  ];

  bool isShowingTrash = false;

  final TextEditingController _searchController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  void _showNewProjectDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CreateNewProject(
          onProjectsUpdated: (updatedProjects) {
            setState(() {
              projects = [...updatedProjects, ...projects];
            });
          },
        );
      },
    );
  }

  List<Project> get activeProjects =>
      projects.where((p) => !p.isDeleted).toList();
  List<Project> get deletedProjects =>
      projects.where((p) => p.isDeleted).toList();

  List<Project> _getFilteredProjects(List<Project> projects) {
    return projects.where((project) {
      final nameMatches = project.name.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );

      bool dateMatches = true;
      if (startDate != null && endDate != null) {
        dateMatches =
            project.lastOrdered.isAfter(startDate!) &&
            project.lastOrdered.isBefore(endDate!.add(Duration(days: 1)));
      }

      return nameMatches && dateMatches;
    }).toList();
  }

  String _formatDate(DateTime? date, bool isStartDate) {
    if (date == null) {
      return isStartDate ? 'Start date' : 'End date';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDatePicker(bool isStartDate) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2020),
      maxTime: DateTime(2025, 12, 31), // Sửa thành 31/12/2025
      onConfirm: (date) {
        setState(() {
          if (isStartDate) {
            startDate = date;
            if (endDate == null || endDate!.isBefore(startDate!)) {
              endDate = date;
            }
          } else {
            endDate = date;
            if (startDate == null || startDate!.isAfter(endDate!)) {
              startDate = date;
            }
          }
        });
      },
      currentTime: isStartDate
          ? startDate ?? DateTime.now()
          : endDate ?? DateTime.now(),
      locale: LocaleType.en,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredActiveProjects = _getFilteredProjects(activeProjects);
    final filteredDeletedProjects = _getFilteredProjects(deletedProjects);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: const SideBar(selectedIndex: 0),
      body: Stack(
        children: [
          Positioned(
            top: 70.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.h),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search project name',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14.h,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[500],
                              size: 20.h,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.grey[500],
                                      size: 20.h,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 16.w,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showDatePicker(true),
                                child: Container(
                                  height: 40.h, // Thêm chiều cao cố định
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: startDate != null
                                          ? Colors.blue
                                          : Colors.grey[500]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // Căn đều các phần tử
                                    children: [
                                      Expanded(
                                        // Wrap Text trong Expanded
                                        child: Text(
                                          _formatDate(startDate, true),
                                          style: TextStyle(
                                            color: startDate != null
                                                ? Colors.blue
                                                : Colors.grey[500],
                                            fontSize: 14.h,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Xử lý text dài
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Giữ các icon sát nhau
                                        children: [
                                          if (startDate != null)
                                            IconButton(
                                              constraints:
                                                  BoxConstraints(), // Bỏ padding mặc định
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.w,
                                              ),
                                              icon: Icon(
                                                Icons.clear,
                                                color: Colors.grey[600],
                                                size: 18.h,
                                              ),
                                              onPressed: () => setState(
                                                () => startDate = null,
                                              ),
                                            ),
                                          Icon(
                                            Icons.calendar_today,
                                            color: Colors.grey[600],
                                            size: 18.h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showDatePicker(false),
                                child: Container(
                                  height: 40.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: endDate != null
                                          ? Colors.blue
                                          : Colors.grey[500]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _formatDate(endDate, false),
                                          style: TextStyle(
                                            color: endDate != null
                                                ? Colors.blue
                                                : Colors.grey[500],
                                            fontSize: 14.h,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (endDate != null)
                                            IconButton(
                                              constraints: BoxConstraints(),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.w,
                                              ),
                                              icon: Icon(
                                                Icons.clear,
                                                color: Colors.grey[600],
                                                size: 18.h,
                                              ),
                                              onPressed: () => setState(
                                                () => endDate = null,
                                              ),
                                            ),
                                          Icon(
                                            Icons.calendar_today,
                                            color: Colors.grey[600],
                                            size: 18.h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isShowingTrash = !isShowingTrash;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isShowingTrash ? 'Go Back' : 'Trash',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.h,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      isShowingTrash
                                          ? Icons.arrow_back
                                          : Icons.delete_outline,
                                      color: Colors.black,
                                      size: 20.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isShowingTrash
                                ? SizedBox.shrink()
                                : GestureDetector(
                                    onTap: _showNewProjectDialog,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.buttonGreen,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Add New Project',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.h,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Icon(
                                            Icons.add,
                                            color: Colors.black,
                                            size: 20.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isShowingTrash
                        ? TrashCard(
                            deletedProjects: filteredDeletedProjects,
                            onRestore: (project) {
                              setState(() {
                                activeProjects.add(project);
                              });
                            },
                          )
                        : ProjectListCard(
                            activeProjects: filteredActiveProjects,
                          ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: "Projects Overview"),
          ),
        ],
      ),
    );
  }
}
