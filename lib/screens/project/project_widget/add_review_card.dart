import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/review_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/providers/review_provider.dart';
import 'package:provider/provider.dart';

class AddReviewCard extends StatefulWidget {
  const AddReviewCard({
    super.key,
    required this.vendor,
    this.isEditing = false,
  });
  final bool isEditing;
  final Reviewer vendor;

  @override
  State<AddReviewCard> createState() => _AddReviewCardState();
}

class _AddReviewCardState extends State<AddReviewCard> {
  int _rating = 0;
  TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditing) {
        fetchReview();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _reviewController.dispose();
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

  Future<void> _handleSubmit() async {
    if (_rating == 0) {
      _showOverlaySnackBar('Please select a rating');
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      _showOverlaySnackBar('Please enter your review');
      return;
    }

    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    bool success = await reviewProvider.createReviewVendor(
      vendorId: widget.vendor.id,
      rating: _rating,
      comment: _reviewController.text.trim(),
    );
    if (success) {
      _showOverlaySnackBar(
        'Review submitted successfully',
        backgroundColor: Colors.green,
      );
      Navigator.of(context).pop();
    } else if (!success && reviewProvider.errorMessage != null) {
      _showOverlaySnackBar(
        reviewProvider.errorMessage ?? 'Failed to submit review',
      );
    }
  }

  Future<void> _handleUpdate() async {
    if (_rating == 0) {
      _showOverlaySnackBar('Please select a rating');
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      _showOverlaySnackBar('Please enter your review');
      return;
    }

    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    bool success = await reviewProvider.updateReviewVendor(
      reviewId: reviewProvider.reviewOfUser!.id,
      vendorId: widget.vendor.id,
      rating: _rating,
      comment: _reviewController.text.trim(),
    );
    if (success) {
      _showOverlaySnackBar(
        'Review updated successfully',
        backgroundColor: Colors.green,
      );
      Navigator.of(context).pop();
    } else if (!success && reviewProvider.errorMessage != null) {
      _showOverlaySnackBar(
        reviewProvider.errorMessage ?? 'Failed to update review',
      );
    }
  }

  Future<void> fetchReview() async {
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    try {
      final review = await reviewProvider.fetchReview(widget.vendor.id);
      if (review) {
        setState(() {
          _rating = reviewProvider.reviewOfUser!.rating;
          _reviewController.text = reviewProvider.reviewOfUser!.comment;
        });
      }
    } catch (e) {
      print('Error fetching review: $e');
      _showOverlaySnackBar('Failed to load review');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
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
                            'Rate',
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Rating your experience for ${widget.vendor.businessName}',
                                      style: TextStyle(
                                        fontSize: 14.h,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(5, (index) {
                                        final starValue = index + 1;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _rating = starValue;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4.w,
                                            ),
                                            child: Icon(
                                              starValue <= _rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: starValue <= _rating
                                                  ? Colors.orange
                                                  : Colors.grey[400],
                                              size: 36.h,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Review input
                              TextField(
                                controller: _reviewController,
                                decoration: InputDecoration(
                                  hintText: 'Input your review here',
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
                              !widget.isEditing
                                  ? InkWell(
                                      onTap: () {
                                        _handleSubmit();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: reviewProvider.isLoading
                                              ? AppColors.buttonGreen
                                                    .withOpacity(0.6)
                                              : AppColors.buttonGreen,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(6),
                                          ),
                                        ),
                                        child: reviewProvider.isLoading
                                            ? Center(
                                                child: SizedBox(
                                                  width: 20.w,
                                                  height: 20.h,
                                                  child: const CircularProgressIndicator(
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
                                    )
                                  : (widget.isEditing &&
                                        reviewProvider
                                                .reviewOfUser
                                                ?.numberEdit ==
                                            0)
                                  ? InkWell(
                                      onTap: () {
                                        _handleUpdate();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: reviewProvider.isLoading
                                              ? AppColors.buttonGreen
                                                    .withOpacity(0.6)
                                              : AppColors.buttonGreen,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(6),
                                          ),
                                        ),
                                        child: reviewProvider.isLoading
                                            ? Center(
                                                child: SizedBox(
                                                  width: 20.w,
                                                  height: 20.h,
                                                  child: const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                'Update',
                                                style: TextStyle(
                                                  fontSize: 14.h,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          reviewProvider.isLoading
                              ? Positioned.fill(
                                  child: Container(
                                    color: Colors.white.withOpacity(0.6),
                                    child: Center(
                                      child: SizedBox(
                                        width: 30.w,
                                        height: 30.h,
                                        child: const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.buttonGreen,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
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
