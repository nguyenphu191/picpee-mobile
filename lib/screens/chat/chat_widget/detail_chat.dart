import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/message_model.dart';
import 'chat_header.dart';
import 'chat_input.dart';

class DetailChat extends StatefulWidget {
  final Map<String, String> user;
  final List<MessageModel> messages;
  final Function(MessageModel) onSendMessage;
  final VoidCallback onClose;

  const DetailChat({
    super.key,
    required this.user,
    required this.messages,
    required this.onSendMessage,
    required this.onClose,
  });

  @override
  State<DetailChat> createState() => _DetailChatState();
}

class _DetailChatState extends State<DetailChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool isShowingImageGallery = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<MessageModel> get chatMessages {
    return widget.messages
        .where(
          (m) =>
              (m.senderId == widget.user['id'] && m.receiverId == 'me') ||
              (m.senderId == 'me' && m.receiverId == widget.user['id']),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<MessageModel> get chatImages {
    return widget.messages
        .where(
          (msg) =>
              msg.isImage &&
              (msg.senderId == widget.user['id'] ||
                  msg.receiverId == widget.user['id']) &&
              (msg.senderId == 'me' || msg.receiverId == 'me'),
        )
        .toList();
  }

  bool isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      receiverId: widget.user['id']!,
      content: text,
      timestamp: DateTime.now(),
    );

    widget.onSendMessage(newMessage);
    _messageController.clear();
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        final newMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'me',
          receiverId: widget.user['id']!,
          content: image.path,
          fileName: image.name,
          timestamp: DateTime.now(),
          isImage: true,
        );

        widget.onSendMessage(newMessage);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _toggleImageGallery() {
    setState(() {
      isShowingImageGallery = !isShowingImageGallery;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ChatHeader(
              userName: widget.user['name']!,
              onClose: widget.onClose,
              onImageGalleryOpen: _toggleImageGallery,
              avatar: widget.user['avatar']!,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: EdgeInsets.all(16.w),
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final msg = chatMessages[index];
                        final isMe = msg.senderId == 'me';
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 4.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.black87 : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: msg.isImage
                                ? Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 200.w,
                                      maxHeight: 200.h,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: isNetworkImage(msg.content)
                                          ? Image.network(
                                              msg.content,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value:
                                                        loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey[600],
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Image.file(
                                              File(msg.content),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey[600],
                                                      ),
                                                    );
                                                  },
                                            ),
                                    ),
                                  )
                                : Text(
                                    msg.content,
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 14.h,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                  ChatInput(
                    messageController: _messageController,
                    onSendMessage: _sendMessage,
                    onPickImage: _pickAndSendImage,
                  ),
                ],
              ),
            ),
          ],
        ),

        if (isShowingImageGallery)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleImageGallery,
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),

        // Sidebar
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          right: isShowingImageGallery ? 0 : -280.w,
          width: 280.w,
          child: Material(
            elevation: 8,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Shared Images',
                        style: TextStyle(
                          fontSize: 16.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, size: 20.h),
                        onPressed: _toggleImageGallery,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.h),
                    itemCount: chatImages.length,
                    itemBuilder: (context, index) {
                      final msg = chatImages[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          leading: Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey[200],
                            ),
                            child: isNetworkImage(msg.content)
                                ? Image.network(
                                    msg.content,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.image,
                                        color: Colors.grey[600],
                                      );
                                    },
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.file(
                                      File(msg.content),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.image,
                                              color: Colors.grey[600],
                                            );
                                          },
                                    ),
                                  ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  msg.displayName,
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                msg.senderId == 'me' ? 'You' : 'Other',
                                style: TextStyle(
                                  fontSize: 12.h,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'Sent ${msg.timestamp.day}/${msg.timestamp.month}/${msg.timestamp.year}',
                            style: TextStyle(
                              fontSize: 12.h,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.download,
                              color: Colors.grey[600],
                              size: 20.h,
                            ),
                            onPressed: () {},
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: isNetworkImage(msg.content)
                                          ? Image.network(
                                              msg.content,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      width: 300.w,
                                                      height: 200.h,
                                                      color: Colors.grey[300],
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        size: 50,
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Image.file(
                                              File(msg.content),
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      width: 300.w,
                                                      height: 200.h,
                                                      color: Colors.grey[300],
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        size: 50,
                                                      ),
                                                    );
                                                  },
                                            ),
                                    ),
                                    SizedBox(height: 16.h),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Close'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
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
            ),
          ),
        ),
      ],
    );
  }
}
