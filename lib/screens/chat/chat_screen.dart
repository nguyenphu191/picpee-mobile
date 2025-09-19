import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/message_model.dart';
import 'package:picpee_mobile/screens/chat/chat_widget/user_list.dart';
import 'package:picpee_mobile/screens/chat/chat_widget/detail_chat.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? selectedUserId;

  final List<Map<String, String>> users = [
    {
      'id': 'u1',
      'name': 'Alice',
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
    },
    {'id': 'u2', 'name': 'Bob', 'avatar': ''},
    {'id': 'u3', 'name': 'Charlie', 'avatar': ''},
  ];

  final List<MessageModel> messages = [
    MessageModel(
      id: 'msg1',
      senderId: 'me',
      receiverId: 'u1',
      content: 'https://picsum.photos/400/300?random=1',
      fileName: 'Project Design.jpg',
      isImage: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    MessageModel(
      id: 'msg2',
      senderId: 'u1',
      receiverId: 'me',
      content: 'https://picsum.photos/400/300?random=2',
      fileName: 'Meeting Notes.png',
      isImage: true,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MessageModel(
      id: 'm3',
      senderId: 'u2',
      receiverId: 'me',
      content: 'Check this image',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isImage: false,
    ),
    MessageModel(
      id: 'm4',
      senderId: 'me',
      receiverId: 'u2',
      content: 'Nice!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
  ];

  void _onSendMessage(MessageModel message) {
    setState(() {
      messages.add(message);
    });
  }

  void _onSelectUser(String userId) {
    setState(() {
      selectedUserId = userId;
    });
  }

  void _onCloseChat() {
    setState(() {
      selectedUserId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      drawer: const SideBar(selectedIndex: 3),
      body: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.all(16.h),
              padding: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: selectedUserId == null
                  ? UserList(
                      users: users,
                      messages: messages,
                      onSelectUser: _onSelectUser,
                    )
                  : DetailChat(
                      user: users.firstWhere((u) => u['id'] == selectedUserId),
                      messages: messages,
                      onSendMessage: _onSendMessage,
                      onClose: _onCloseChat,
                    ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: "Chats"),
          ),
        ],
      ),
    );
  }
}
