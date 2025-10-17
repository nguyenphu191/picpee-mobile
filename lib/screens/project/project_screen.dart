import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/providers/project_provider.dart';
import 'package:picpee_mobile/screens/project/project_widget/create_new_project.dart';
import 'package:picpee_mobile/screens/project/project_widget/project_list_card.dart';
import 'package:picpee_mobile/screens/project/project_widget/trash_card.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';
import 'package:provider/provider.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool isShowingTrash = false;
  final TextEditingController _searchController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProjects();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProjects() async {
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    final success = await projectProvider.fetchProjects();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load projects'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _refreshProjects() async {
    await _fetchProjects();
  }

  void _showNewProjectDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CreateNewProject(
          onProjectCreated: () {
            _fetchProjects(); // Refresh after creating
          },
        );
      },
    );
  }

  void _showEditProjectDialog(ProjectModel project) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CreateNewProject(
          project: project,
          onProjectCreated: () {
            _fetchProjects(); // Refresh after editing
          },
        );
      },
    );
  }

  Future<void> _moveToTrash(ProjectModel project) async {
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    final success = await projectProvider.moveToTrash(project.id);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to move project to trash'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _restoreProject(ProjectModel project) async {
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    final success = await projectProvider.restoreProject(project.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${project.name} restored successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to restore project'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _permanentlyDeleteProject(ProjectModel project) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Forever'),
          content: Text(
            'Are you sure you want to permanently delete "${project.name}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete Forever'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final projectProvider = Provider.of<ProjectProvider>(
        context,
        listen: false,
      );
      final success = await projectProvider.deleteProject(project.id);

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete project'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
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
      maxTime: DateTime(2030, 12, 31),
      onConfirm: (date) {
        setState(() {
          if (isStartDate) {
            startDate = date;
            if (endDate != null && endDate!.isBefore(startDate!)) {
              endDate = date;
            }
          } else {
            endDate = date;
            if (startDate != null && startDate!.isAfter(endDate!)) {
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

  List<ProjectModel> _getFilteredProjects(List<ProjectModel> projects) {
    return projects.where((project) {
      // Search filter
      final matchesSearch = project.name.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );

      // Date filter
      bool matchesDateRange = true;
      if (startDate != null || endDate != null) {
        if (project.createdTime.isNotEmpty) {
          try {
            final projectDate = ProjectModel.timestampStringToDateTime(
              project.createdTime.replaceAll(RegExp(r'[^\d]'), ''),
            );

            if (startDate != null && projectDate.isBefore(startDate!)) {
              matchesDateRange = false;
            }
            if (endDate != null &&
                projectDate.isAfter(endDate!.add(Duration(days: 1)))) {
              matchesDateRange = false;
            }
          } catch (e) {
            // If date parsing fails, include the project
            matchesDateRange = true;
          }
        }
      }

      return matchesSearch && matchesDateRange;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        final allProjects = projectProvider.projects;
        final activeProjects = allProjects
            .where((project) => project.status == 'ACTIVE')
            .toList();
        final inactiveProjects = allProjects
            .where((project) => project.status == 'INACTIVE')
            .toList();

        final filteredActiveProjects = _getFilteredProjects(activeProjects);
        final filteredInactiveProjects = _getFilteredProjects(inactiveProjects);

        return Scaffold(
          backgroundColor: Colors.grey[50],
          drawer: const SideBar(selectedIndex: 0),
          body: RefreshIndicator(
            onRefresh: _refreshProjects,
            child: Stack(
              children: [
                Positioned(
                  top: 80.h,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      // Filters Container
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          children: [
                            // Search Field
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

                            // Date Range Filters
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _showDatePicker(true),
                                    child: Container(
                                      height: 40.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.grey[500]!,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _formatDate(startDate, true),
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 14.h,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (startDate != null)
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
                                          color: Colors.grey[500]!,
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
                                                color: Colors.grey[500],
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

                            // Action Buttons
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
                                if (!isShowingTrash)
                                  GestureDetector(
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

                      // Content Area
                      Expanded(
                        child: isShowingTrash
                            ? TrashCard(
                                deletedProjects: filteredInactiveProjects,
                                onRestore: _restoreProject,
                                onPermanentDelete: _permanentlyDeleteProject,
                              )
                            : ProjectListCard(
                                activeProjects: filteredActiveProjects,
                                onEdit: _showEditProjectDialog,
                                onMoveToTrash: _moveToTrash,
                              ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ProfileHeader(title: "Projects Overview"),
                ),
                if (projectProvider.loading)
                  Container(color: Colors.black.withOpacity(0.3)),
                if (projectProvider.loading)
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10.r,
                            offset: Offset(0, 5.h),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.buttonGreen,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
