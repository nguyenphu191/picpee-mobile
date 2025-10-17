import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:provider/provider.dart';

class ChecklistSide extends StatefulWidget {
  const ChecklistSide({super.key, required this.orderId});
  final int orderId;

  @override
  State<ChecklistSide> createState() => _ChecklistSideState();
}

class _ChecklistSideState extends State<ChecklistSide> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchChecklist();
    });
  }

  Future<void> _fetchChecklist() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.fetchChecklist(widget.orderId);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load checklist'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final _checklist = orderProvider.checklist;

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._checklist.asMap().entries.map((entry) {
                    final item = entry.value;
                    return Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (bool? value) {
                            // Handle checkbox state change
                          },
                          activeColor: Colors.black,
                        ),
                        Expanded(
                          child: Text(
                            item.skillAddonsName,
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            // Loading overlay
            if (orderProvider.loading)
              Container(color: Colors.black.withOpacity(0.3)),
            if (orderProvider.loading)
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
                      CircularProgressIndicator(color: AppColors.buttonGreen),
                      SizedBox(height: 8.h),
                      Text(
                        "Loading...",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
