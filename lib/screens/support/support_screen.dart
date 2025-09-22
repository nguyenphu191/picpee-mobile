import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/ticket_model.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';
import 'support_widget/create_ticket_widget.dart';
import 'support_widget/ticket_manager_widget.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List<Ticket> tickets = [
    Ticket(
      id: '001',
      title: 'Payment Issue with Credit Card',
      details: 'Cannot process payment with my credit card',
      type: 'Ticket Payment',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      imgUrl: 'https://picsum.photos/200/300',
      status: 'Pending',
      comments: [
        Comment(
          id: 'c001',
          content:
              'We are investigating this issue. Please provide more details about the error message.',
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          authorName: 'Support Team',
        ),
      ],
    ),
    Ticket(
      id: '002',
      title: 'Login Problem',
      details: 'Cannot login to my account',
      type: 'Ticket Account',
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
      status: 'Approved',
      comments: [
        Comment(
          id: 'c002',
          content:
              'Your account has been verified and the login issue should be resolved.',
          createdAt: DateTime.now().subtract(Duration(hours: 1)),
          authorName: 'Support Team',
        ),
      ],
    ),
    Ticket(
      id: '003',
      title: 'App Crash on Startup',
      details: 'The app crashes immediately after launching',
      type: 'Ticket Order',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      status: 'Rejected',
      comments: [],
    ),
  ];

  void _handleCreateTicket(String title, String details, String type) {
    final newTicket = Ticket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      details: details,
      type: type,
      createdAt: DateTime.now(),
      status: 'Pending',
      comments: [],
    );

    setState(() {
      tickets.insert(0, newTicket);
    });
  }

  void _handleDeleteTicket(String ticketId) {
    setState(() {
      tickets.removeWhere((ticket) => ticket.id == ticketId);
    });
  }

  void _handleAddComment(String ticketId, String commentContent) {
    setState(() {
      final ticketIndex = tickets.indexWhere((ticket) => ticket.id == ticketId);
      if (ticketIndex != -1) {
        final newComment = Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: commentContent,
          createdAt: DateTime.now(),
          authorName: 'You',
        );

        final updatedComments = List<Comment>.from(
          tickets[ticketIndex].comments,
        );
        updatedComments.add(newComment);

        tickets[ticketIndex] = tickets[ticketIndex].copyWith(
          comments: updatedComments,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      drawer: const SideBar(selectedIndex: 4),
      body: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.h),
              child: Column(
                children: [
                  CreateTicketWidget(onCreateTicket: _handleCreateTicket),
                  SizedBox(height: 24.h),
                  TicketManagerWidget(
                    tickets: tickets,
                    onDeleteTicket: _handleDeleteTicket,
                    onAddComment: _handleAddComment,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: "Support"),
          ),
        ],
      ),
    );
  }
}
