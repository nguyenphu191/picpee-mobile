import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/screens/payment/payment_screen.dart';

class TopUpDialog extends StatefulWidget {
  const TopUpDialog({super.key, this.onProjectsUpdated});
  final void Function(List<Project>)? onProjectsUpdated;
  @override
  State<TopUpDialog> createState() => _TopUpDialogState();
}

class _TopUpDialogState extends State<TopUpDialog> {
  final TextEditingController _amountController = TextEditingController();
  final List<int> suggestedAmounts = [5, 10, 20, 50, 100, 200, 500, 750, 1000];
  @override
  void initState() {
    super.initState();
    _amountController.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 380.h,
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
                        'Top Up',
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
                        'Choose a suggested amount',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 100.h,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8.w,
                                crossAxisSpacing: 8.h,
                                childAspectRatio: 0.31.h,
                              ),
                          itemCount: suggestedAmounts.length,
                          itemBuilder: (context, index) {
                            final amount = suggestedAmounts[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _amountController.text = amount.toString();
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        _amountController.text ==
                                            amount.toString()
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  '\$ $amount',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Other amount',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14.h, color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            width: 40.w,
                            alignment: Alignment.center,
                            child: Text(
                              '\$',
                              style: TextStyle(
                                fontSize: 16.h,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          hintText: 'Input other amount',
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
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _amountController.text = value;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 16.h),

                      InkWell(
                        onTap: () {
                          // Parse the amount from the controller
                          final amount =
                              double.tryParse(_amountController.text) ?? 0.0;
                          if (amount <= 0) {
                            // Show error for invalid amount
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a valid amount'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Close this dialog and navigate to PaymentScreen
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentScreen(amount: amount),
                            ),
                          );
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
                          child: Text(
                            'Add Fund',
                            style: TextStyle(
                              fontSize: 16.h,
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
  }
}
