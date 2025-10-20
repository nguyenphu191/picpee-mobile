import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrientationWidget extends StatefulWidget {
  final String selectedOrientation;
  final ValueChanged<String> onChanged;

  const OrientationWidget({
    Key? key,
    required this.selectedOrientation,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OrientationWidget> createState() => _OrientationWidgetState();
}

class _OrientationWidgetState extends State<OrientationWidget> {
  late String _selectedOrientation;

  @override
  void initState() {
    super.initState();
    _selectedOrientation = widget.selectedOrientation;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Orientation',
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              // Horizontal Option
              Expanded(
                child: _buildOrientationOption(
                  title: 'Horizontal',
                  value: 'Horizontal',
                  icon: Icons.crop_landscape,
                ),
              ),
              SizedBox(width: 12.w),

              // Vertical Option
              Expanded(
                child: _buildOrientationOption(
                  title: 'Vertical',
                  value: 'Vertical',
                  icon: Icons.crop_portrait,
                ),
              ),
              SizedBox(width: 12.w),

              // Both Option
              Expanded(
                child: _buildOrientationOption(
                  title: 'Horizontal + Vertical',
                  value: 'Both',
                  icon: Icons.crop_free,
                  showBothIcons: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrientationOption({
    required String title,
    required String value,
    required IconData icon,
    bool showBothIcons = false,
  }) {
    final isSelected = _selectedOrientation == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOrientation = value;
        });
        widget.onChanged(value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[400]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Icon(s)
            if (showBothIcons)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.crop_landscape,
                      size: 24.h,
                      color: isSelected ? Colors.green : Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.add, size: 16.h, color: Colors.grey[600]),
                  SizedBox(width: 4.w),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.crop_portrait,
                      size: 24.h,
                      color: isSelected ? Colors.green : Colors.grey[700],
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 32.h,
                  color: isSelected ? Colors.green : Colors.grey[700],
                ),
              ),
            SizedBox(height: 12.h),

            // Radio + Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.h,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? Colors.green : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
