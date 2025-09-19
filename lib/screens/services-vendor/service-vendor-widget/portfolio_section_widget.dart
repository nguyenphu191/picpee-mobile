import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:picpee_mobile/widgets/before_after_card.dart';
import 'upload_portfolio_dialog.dart';

class PortfolioSectionWidget extends StatefulWidget {
  final String serviceTitle;

  const PortfolioSectionWidget({Key? key, required this.serviceTitle})
    : super(key: key);

  @override
  State<PortfolioSectionWidget> createState() => _PortfolioSectionWidgetState();
}

class _PortfolioSectionWidgetState extends State<PortfolioSectionWidget> {
  List<PortfolioItem> portfolioItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add Gallery Image Container
        GestureDetector(
          onTap: _showUploadDialog,
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[400]!,
                style: BorderStyle.solid,
                width: 1.2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.grey, size: 24.h),
                  SizedBox(height: 4.h),
                  Text(
                    'Add Gallery Image\nfor ${widget.serviceTitle}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.h, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Display Portfolio Items
        if (portfolioItems.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 150.w / 100.h,
            ),
            itemCount: portfolioItems.length,
            itemBuilder: (context, index) {
              final item = portfolioItems[index];
              return _buildPortfolioCard(item, index);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildPortfolioCard(PortfolioItem item, int index) {
    return Stack(
      children: [
        Container(
          width: 150.w,
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            // Thêm ClipRRect để bo góc ảnh
            borderRadius: BorderRadius.circular(8),
            child: item.type == 'before_after'
                ? CustomBeforeAfterSlider(
                    beforeImageFile: item.beforeImage,
                    afterImageFile: item.afterImage,
                    width: 150.w,
                    height: 100.h,
                  )
                : Image.file(File(item.singleImage!.path), fit: BoxFit.cover),
          ),
        ),

        // Delete button
        Positioned(
          top: 4.h,
          right: 4.w,
          child: GestureDetector(
            onTap: () => _removePortfolioItem(index),
            child: Container(
              padding: EdgeInsets.all(4.h),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 14.h),
            ),
          ),
        ),
      ],
    );
  }

  void _showUploadDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => UploadPortfolioDialog(),
    );

    if (result != null) {
      setState(() {
        if (result['type'] == 'before_after') {
          portfolioItems.add(
            PortfolioItem(
              type: 'before_after',
              beforeImage: result['beforeImage'],
              afterImage: result['afterImage'],
            ),
          );
        } else if (result['type'] == 'single_batch') {
          List<XFile> images = result['images'];
          for (var image in images) {
            portfolioItems.add(
              PortfolioItem(type: 'single', singleImage: image),
            );
          }
        }
      });
    }
  }

  void _removePortfolioItem(int index) {
    setState(() {
      portfolioItems.removeAt(index);
    });
  }
}

class PortfolioItem {
  final String type;
  final XFile? singleImage;
  final XFile? beforeImage;
  final XFile? afterImage;

  PortfolioItem({
    required this.type,
    this.singleImage,
    this.beforeImage,
    this.afterImage,
  });
}
