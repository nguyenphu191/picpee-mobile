import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:provider/provider.dart';

class DisputeCard extends StatefulWidget {
  const DisputeCard({super.key, required this.order});
  final OrderModel order;

  @override
  State<DisputeCard> createState() => _DisputeCardState();
}

class _DisputeCardState extends State<DisputeCard> {
  String? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();

  final List<String> _disputeReasons = [
    'Communication gaps can cause misunderstandings in design.',
    'Designers sometimes clash with the project\'s vision, leading to frustration.',
    'Inconsistent feedback leads to delays and confusion in design.',
    'Limited availability of designers can hinder timely project progress.',
    'Different design styles can clash with the overall branding strategy.',
    'Budget constraints may restrict the quality of design work.',
  ];

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
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

  Future<void> disputeOrder() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    String reason = _selectedReason ?? '';

    // If "Other" is selected, use the text from controller
    if (_selectedReason == 'Other' &&
        _otherReasonController.text.trim().isNotEmpty) {
      reason = _otherReasonController.text.trim();
    }

    if (reason.isEmpty) {
      _showOverlaySnackBar('Please select a reason for dispute.');
      return;
    }

    try {
      final success = await orderProvider.disputeOrder(widget.order.id, reason);
      if (success) {
        Navigator.of(context).pop(); // Close the dialog
        _showOverlaySnackBar(
          'Dispute request submitted successfully.',
          backgroundColor: Colors.green,
        );
      } else {
        _showOverlaySnackBar(
          'Failed to submit dispute request. Please try again.',
        );
      }
    } catch (e) {
      _showOverlaySnackBar(
        'Failed to submit dispute request. Please try again.',
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
            height: 520.h, // Increased height for scrollable content
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
                            'Dispute order',
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
                  bottom: 0,
                  child: ClipPath(
                    clipper: TopNotchClipper(),
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                        top: 24.h,
                        bottom: 16.h,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'The reason you want to stop this order and get a refund:',
                            style: TextStyle(
                              fontSize: 14.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Scrollable list of reasons
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // Radio buttons for predefined reasons
                                  ..._disputeReasons.map((reason) {
                                    return RadioListTile<String>(
                                      value: reason,
                                      groupValue: _selectedReason,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedReason = value;
                                        });
                                      },
                                      title: Text(
                                        reason,
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                      activeColor: AppColors.brandGreen,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                    );
                                  }).toList(),

                                  // "Other" option with text field
                                  RadioListTile<String>(
                                    value: 'Other',
                                    groupValue: _selectedReason,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedReason = value;
                                      });
                                    },
                                    title: Text(
                                      'Other',
                                      style: TextStyle(
                                        fontSize: 14.h,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    activeColor: AppColors.brandGreen,
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                  ),

                                  // Show text field when "Other" is selected
                                  if (_selectedReason == 'Other')
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 32.w,
                                        right: 0,
                                        top: 8.h,
                                      ),
                                      child: TextField(
                                        controller: _otherReasonController,
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Please specify your reason...',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.h,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey[500]!,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.brandGreen,
                                              width: 1.5,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 8.h,
                                          ),
                                        ),
                                      ),
                                    ),

                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                          ),

                          // Submit button
                          InkWell(
                            onTap: orderProvider.loading ? null : disputeOrder,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: orderProvider.loading
                                    ? AppColors.buttonGreen.withOpacity(0.6)
                                    : AppColors.buttonGreen,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: orderProvider.loading
                                  ? Center(
                                      child: SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
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
