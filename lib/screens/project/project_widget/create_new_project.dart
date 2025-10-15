import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/providers/project_provider.dart';
import 'package:provider/provider.dart';

class CreateNewProject extends StatefulWidget {
  const CreateNewProject({super.key, this.project, this.onProjectCreated});
  final ProjectModel? project;
  final VoidCallback? onProjectCreated;
  @override
  State<CreateNewProject> createState() => _CreateNewProjectState();
}

class _CreateNewProjectState extends State<CreateNewProject> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool get isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.project!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    bool success;

    if (isEditing) {
      success = await projectProvider.updateProject(
        _nameController.text.trim(),
        widget.project!.id,
      );
    } else {
      success = await projectProvider.createProject(
        _nameController.text.trim(),
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.of(context).pop();
      widget.onProjectCreated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Project updated successfully'
                : 'Project created successfully',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Failed to update project' : 'Failed to create project',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 280.h,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.background3),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 11, 121, 14),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16.w,
                      top: 20.h,
                      child: Text(
                        isEditing ? 'Edit Project' : 'New Project',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonGreen,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20.h,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 24.h,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 20.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 60.h,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopNotchClipper(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project name',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Input your project name',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      InkWell(
                        onTap: () {
                          if (!_isLoading) {
                            _handleSubmit();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.buttonGreen,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.buttonGreen,
                                    ),
                                  ),
                                )
                              : Text(
                                  isEditing ? 'Save' : 'Create',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
