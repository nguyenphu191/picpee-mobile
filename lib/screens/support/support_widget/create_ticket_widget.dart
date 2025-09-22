import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';

class CreateTicketWidget extends StatefulWidget {
  final Function(String title, String details, String type) onCreateTicket;

  const CreateTicketWidget({super.key, required this.onCreateTicket});

  @override
  State<CreateTicketWidget> createState() => _CreateTicketWidgetState();
}

class _CreateTicketWidgetState extends State<CreateTicketWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String _selectedTicketType = 'Ticket Payment';

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _handleCreateTicket() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onCreateTicket(
      _titleController.text.trim(),
      _detailsController.text.trim(),
      _selectedTicketType,
    );

    _titleController.clear();
    _detailsController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleCancel() {
    _titleController.clear();
    _detailsController.clear();
  }

  void _onTicketTypeChanged(String type) {
    setState(() {
      _selectedTicketType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Ticket',
              style: TextStyle(
                fontSize: 18.h,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 16.h),

            // Title Input
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Short, descriptive title',
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 14.h),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                style: TextStyle(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Details
            Text(
              'Details',
              style: TextStyle(
                fontSize: 16.h,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 8.h),

            // Details Input
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: TextField(
                controller: _detailsController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Any additional details...',
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 14.h),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Dropdown
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTicketType,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black87, fontSize: 14.h),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _onTicketTypeChanged(newValue);
                    }
                  },
                  items:
                      <String>[
                        'Ticket Payment',
                        'Ticket Order',
                        'Ticket Account',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Action Buttons
            Row(
              children: [
                Container(
                  width: 38.h,
                  height: 38.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.attach_file,
                      size: 20.h,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                const Spacer(),

                TextButton(
                  onPressed: _handleCancel,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                ElevatedButton(
                  onPressed: _handleCreateTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Create',
                    style: TextStyle(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
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
