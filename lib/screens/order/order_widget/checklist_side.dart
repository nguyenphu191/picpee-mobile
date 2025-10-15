import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/utils/mock_order_data.dart';

class ChecklistSide extends StatefulWidget {
  const ChecklistSide({super.key});

  @override
  State<ChecklistSide> createState() => _ChecklistSideState();
}

class _ChecklistSideState extends State<ChecklistSide> {
  List<String> _checklist = [
    "Upload Files",
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._checklist.asMap().entries.map((entry) {
            final item = entry.value;
            return Container(
              child: Row(
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
                      item,
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
