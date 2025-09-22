import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/models/ticket_model.dart';

class TicketManagerWidget extends StatefulWidget {
  final List<Ticket> tickets;
  final Function(String) onDeleteTicket;
  final Function(String, String) onAddComment;

  const TicketManagerWidget({
    super.key,
    required this.tickets,
    required this.onDeleteTicket,
    required this.onAddComment,
  });

  @override
  State<TicketManagerWidget> createState() => _TicketManagerWidgetState();
}

class _TicketManagerWidgetState extends State<TicketManagerWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSearchType = 'All Type';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Ticket> get filteredTickets {
    List<Ticket> filtered = widget.tickets;

    if (_selectedSearchType != 'All Type') {
      filtered = filtered
          .where((ticket) => ticket.type == _selectedSearchType)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      String searchText = _searchController.text.toLowerCase();
      filtered = filtered
          .where(
            (ticket) =>
                ticket.title.toLowerCase().contains(searchText) ||
                ticket.details.toLowerCase().contains(searchText),
          )
          .toList();
    }

    return filtered;
  }

  void _onSearchTypeChanged(String type) {
    setState(() {
      _selectedSearchType = type;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showTicketDetails(BuildContext context, Ticket ticket) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  ticket.title,
                  style: TextStyle(
                    fontSize: 18.h,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 12.h),

                // Image if exists
                if (ticket.imgUrl.isNotEmpty) ...[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ticket.imgUrl,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150.h,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                Container(
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Type: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.h,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            ticket.type,
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                ticket.status,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              ticket.status,
                              style: TextStyle(
                                color: _getStatusColor(ticket.status),
                                fontSize: 12.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        ticket.details.isNotEmpty
                            ? ticket.details
                            : 'No additional details provided.',
                        style: TextStyle(fontSize: 14.h, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                // Comments Section
                Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 8.h),

                // Comments List
                Expanded(
                  child: ticket.comments.isEmpty
                      ? Center(
                          child: Text(
                            'No comments yet',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14.h,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: ticket.comments.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8.h),
                          itemBuilder: (context, index) {
                            final comment = ticket.comments[index];
                            return Container(
                              padding: EdgeInsets.all(12.h),
                              decoration: BoxDecoration(
                                color: comment.authorName == 'You'
                                    ? Colors.blue[50]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: comment.authorName == 'You'
                                      ? Colors.blue[200]!
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        comment.authorName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.h,
                                          color: comment.authorName == 'You'
                                              ? Colors.blue[700]
                                              : Colors.grey[700],
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year} ${comment.createdAt.hour.toString().padLeft(2, '0')}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 10.h,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    comment.content,
                                    style: TextStyle(
                                      fontSize: 13.h,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),

                SizedBox(height: 12.h),

                // Add Comment Section
                Container(
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(fontSize: 14.h),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          // Attach file icon
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.attach_file,
                              size: 18.h,
                              color: Colors.grey[600],
                            ),
                          ),
                          Spacer(),
                          // Action buttons
                          TextButton(
                            onPressed: () {
                              commentController.clear();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red[50],
                              foregroundColor: Colors.red[700],
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              'close',
                              style: TextStyle(fontSize: 14.h),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          ElevatedButton(
                            onPressed: () {
                              if (commentController.text.trim().isNotEmpty) {
                                widget.onAddComment(
                                  ticket.id,
                                  commentController.text.trim(),
                                );
                                commentController.clear();
                                Navigator.of(context).pop();
                                // Reopen dialog to show updated comments
                                Future.delayed(Duration(milliseconds: 100), () {
                                  final updatedTicket = widget.tickets
                                      .firstWhere((t) => t.id == ticket.id);
                                  _showTicketDetails(context, updatedTicket);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              'submit',
                              style: TextStyle(fontSize: 14.h),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 120.h,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 25.h,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 191, 255, 132),
                  child: Center(
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    'Are you sure you want to delete this ticket?',
                    style: TextStyle(fontSize: 12.h, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        widget.onDeleteTicket(ticket.id);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 10.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 10.h,
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
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
              'Your Tickets',
              style: TextStyle(
                fontSize: 18.h,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSearchType,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black87, fontSize: 14.h),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _onSearchTypeChanged(newValue);
                    }
                  },
                  items:
                      <String>[
                        'All Type',
                        'Ticket Payment',
                        'Ticket Order',
                        'Ticket Account',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search tickets...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13.h),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 18.h,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Tickets List
            if (filteredTickets.isEmpty)
              Center(
                child: Text(
                  'No tickets found!',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredTickets.length,
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final ticket = filteredTickets[index];
                  return InkWell(
                    onTap: () => _showTicketDetails(context, ticket),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(16.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ticket.title,
                                  style: TextStyle(
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    ticket.status,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ticket.status,
                                  style: TextStyle(
                                    color: _getStatusColor(ticket.status),
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (ticket.details.isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            Text(
                              ticket.details,
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () =>
                                    _showDeleteConfirmation(context, ticket),
                                borderRadius: BorderRadius.circular(6),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
