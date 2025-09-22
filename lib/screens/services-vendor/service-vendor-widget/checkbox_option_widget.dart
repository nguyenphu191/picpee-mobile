import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxOptionWidget extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool?) onChanged;
  final int index;
  final TextEditingController priceController;

  const CheckboxOptionWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.index,
    required this.priceController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.blue,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (value) ...[
            SizedBox(height: 5.h),
            Row(
              children: [
                SizedBox(width: 48.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[400]!, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '+\$',
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintText: '0',
                              hintStyle: TextStyle(
                                fontSize: 14.h,
                                color: Colors.grey[400],
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final double? price = double.tryParse(value);
                                if (price == null || price < 0) {
                                  priceController.text = '0';
                                  priceController.selection = 
                                    TextSelection.fromPosition(
                                      TextPosition(offset: 1),
                                    );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'add per order',
                          style: TextStyle(
                            fontSize: 12.h,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}