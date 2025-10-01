import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/screens/chat/chat_widget/detail_chat.dart';
import '../../../models/message_model.dart';

class UserList extends StatefulWidget {
  final List<Map<String, String>> users;
  final List<MessageModel> messages;

  const UserList({super.key, required this.users, required this.messages});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'All messages';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredUsers {
    final query = _searchController.text.toLowerCase();
    var filtered = widget.users.where(
      (u) => u['name']!.toLowerCase().contains(query),
    );

    if (_filterType == 'Unread') {
      filtered = filtered.where((u) {
        final lastMsg = widget.messages.lastWhere(
          (m) => m.senderId == u['id'] || m.receiverId == u['id'],
          orElse: () => MessageModel(
            id: '',
            senderId: '',
            receiverId: '',
            content: '',
            timestamp: DateTime.now(),
          ),
        );
        return !lastMsg.isRead && lastMsg.senderId != 'me';
      });
    }

    return filtered.toList();
  }

  void _onChangeFilter(String type) {
    setState(() {
      _filterType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50.h,
          width: double.infinity,
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
          child: Row(
            children: [
              PopupMenuButton<String>(
                offset: Offset(0, 40),
                child: Row(
                  children: [
                    Text(
                      _filterType,
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_drop_down, size: 30.h, color: Colors.grey),
                  ],
                ),
                onSelected: _onChangeFilter,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'All messages',
                    child: Text(
                      'All messages',
                      style: TextStyle(
                        color: _filterType == 'All messages'
                            ? Colors.blue
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.h,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Unread',
                    child: Text(
                      'Unread',
                      style: TextStyle(
                        color: _filterType == 'Unread'
                            ? Colors.blue
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.h,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1.h, color: Colors.grey[300]),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 14.h, color: Colors.grey),
              prefixIcon: Icon(Icons.search, size: 20.h, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 20.h, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              final lastMsg = widget.messages.lastWhere(
                (m) => m.senderId == user['id'] || m.receiverId == user['id'],
                orElse: () => MessageModel(
                  id: '',
                  senderId: '',
                  receiverId: '',
                  content: '',
                  timestamp: DateTime.now(),
                ),
              );
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  leading: user['avatar'] == ""
                      ? CircleAvatar(
                          backgroundColor: Colors.lightGreen,
                          radius: 24.r,
                          child: Text(
                            user['name']![0],
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(user['avatar']!),
                          radius: 24.r,
                        ),
                  title: Text(
                    user['name']!,
                    style: TextStyle(
                      fontSize: 14.h,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    lastMsg.content.isNotEmpty ? lastMsg.content : '',
                    style: TextStyle(
                      fontSize: 12.h,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: lastMsg.content.isNotEmpty
                      ? Text(
                          "${lastMsg.timestamp.hour.toString().padLeft(2, '0')}:${lastMsg.timestamp.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 12.h,
                            color: Colors.grey[600],
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailChat(
                          user: user,
                          onClose: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
