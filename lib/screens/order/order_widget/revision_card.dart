import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:provider/provider.dart';

class RevisionCard extends StatefulWidget {
  const RevisionCard({super.key, required this.order});
  final OrderModel order;

  @override
  State<RevisionCard> createState() => _RevisionCardState();
}

class _RevisionCardState extends State<RevisionCard> {
  TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _noteController.dispose();
  }

  void _showOverlaySnackBar(
    String message, {
    Color backgroundColor = Colors.red,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.h,
        left: 16.w,
        right: 16.w,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.h,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(Duration(seconds: 2), () {
      entry.remove();
    });
  }

  Future<void> revisionOrder() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final note = _noteController.text.trim();
    if (note.isEmpty) {
      _showOverlaySnackBar('Please enter a revision note.');
      return;
    }
    try {
      final succes = await orderProvider.revisionOrder(widget.order.id, note);
      if (succes) {
        Navigator.of(context).pop(); // Close the dialog
        _showOverlaySnackBar(
          'Revision request submitted successfully.',
          backgroundColor: Colors.green,
        );
      } else {
        _showOverlaySnackBar(
          'Failed to submit revision request. Please try again.',
        );
      }
    } catch (e) {
      _showOverlaySnackBar(
        'Failed to submit revision request. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 330.h,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Stack(
              children: [
                // Header
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
                      borderRadius: const BorderRadius.only(
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
                            'Request Revision',
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
                              decoration: const BoxDecoration(
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

                // Content
                Positioned(
                  top: 60.h,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: TopNotchClipper(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 20.h,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _noteController,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Write your revision note here...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14.h,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 1.5,
                                      ),
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
                                    if (!orderProvider.loading) {
                                      revisionOrder();
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: orderProvider.loading
                                          ? AppColors.buttonGreen.withOpacity(
                                              0.6,
                                            )
                                          : AppColors.buttonGreen,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                    child: orderProvider.loading
                                        ? Center(
                                            child: SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            'Submit',
                                            style: TextStyle(
                                              fontSize: 14.h,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
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
      },
    );
  }
}
