import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';

class UploadPortfolioDialog extends StatefulWidget {
  const UploadPortfolioDialog({Key? key}) : super(key: key);

  @override
  State<UploadPortfolioDialog> createState() => _UploadPortfolioDialogState();
}

class _UploadPortfolioDialogState extends State<UploadPortfolioDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  // For single/batch upload
  List<XFile> selectedImages = [];

  // For before/after upload
  XFile? beforeImage;
  XFile? afterImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        selectedImages = images;
      });
    }
  }

  Future<void> _pickBeforeImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        beforeImage = image;
      });
    }
  }

  Future<void> _pickAfterImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        afterImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400.w,
        height: 420.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            // Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60.h,
                padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 16.h),
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.background3),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Upload Portfolio Images',
                      style: TextStyle(
                        color: AppColors.buttonGreen,
                        fontSize: 14.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(4.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.black87,
                          size: 14.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar
            Positioned(
              top: 40.h,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopNotchClipper(),
                child: Container(
                  height: 260.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 48.h,
                        width: double.infinity,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(
                              child: Text(
                                'Before/After',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Single/Batch',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 162.h,
                        width: double.infinity,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildBeforeAfterTab(),
                            _buildSingleBatchTab(),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 12.w,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                ElevatedButton(
                                  onPressed: _canUpload()
                                      ? _uploadImages
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 12.w,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    'Upload',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  Widget _buildBeforeAfterTab() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _pickBeforeImage,
              child: Container(
                height: 162.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    style: BorderStyle.solid,
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: beforeImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(beforeImage!.path),
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            size: 24.h,
                            color: Colors.purple.shade300,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Select Before\nImage',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          SizedBox(width: 5.w),

          Expanded(
            child: GestureDetector(
              onTap: _pickAfterImage,
              child: Container(
                height: 142.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    style: BorderStyle.solid,
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: afterImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(afterImage!.path),
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            size: 24.h,
                            color: Colors.purple.shade300,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Select After Image',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleBatchTab() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: GestureDetector(
        onTap: _pickImages,
        child: Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400,
              style: BorderStyle.solid,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: selectedImages.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.all(8.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(selectedImages[index].path),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      size: 32.h,
                      color: Colors.purple.shade300,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Select Image Files To Upload',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  bool _canUpload() {
    if (_tabController.index == 0) {
      // Before/After tab
      return beforeImage != null && afterImage != null;
    } else {
      // Single/Batch tab
      return selectedImages.isNotEmpty;
    }
  }

  void _uploadImages() {
    if (_tabController.index == 0) {
      // Before/After upload
      Navigator.pop(context, {
        'type': 'before_after',
        'beforeImage': beforeImage,
        'afterImage': afterImage,
      });
    } else {
      // Single/Batch upload
      Navigator.pop(context, {
        'type': 'single_batch',
        'images': selectedImages,
      });
    }
  }
}
