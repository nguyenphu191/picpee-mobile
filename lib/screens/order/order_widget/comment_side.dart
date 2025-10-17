import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/comment_model.dart';
import 'package:picpee_mobile/providers/auth_provider.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:provider/provider.dart';

class CommentSide extends StatefulWidget {
  const CommentSide({super.key, required this.orderId});
  final int orderId;

  @override
  State<CommentSide> createState() => _CommentSideState();
}

class _CommentSideState extends State<CommentSide> {
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  final TextEditingController _replyController = TextEditingController();
  List<XFile> _replyImages = [];

  final TextEditingController _editController = TextEditingController();
  List<XFile> _editImages = [];

  // State tracking variables
  String? _editingCommentId; // Changed to String to support nested comments
  String? _replyingToId; // Changed to String to support nested comments
  int? _replyLevel; // Track the level for replies

  @override
  void dispose() {
    _commentController.dispose();
    _replyController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchComment();
    });
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _pickReplyImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _replyImages.addAll(images);
      });
    }
  }

  void _removeReplyImage(int index) {
    setState(() {
      _replyImages.removeAt(index);
    });
  }

  Future<void> _pickEditImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _editImages.addAll(images);
      });
    }
  }

  void _removeEditImage(int index) {
    setState(() {
      _editImages.removeAt(index);
    });
  }

  Future<void> fetchComment() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.fetchOrderComments(widget.orderId);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load comments'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendComment({
    required String content,
    required List<XFile> images,
    int level = 1,
    int? parentCommentId,
  }) async {
    if (content.isEmpty && images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a message or select images'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final Map<String, dynamic> commentData = {
      'orderId': widget.orderId,
      'content': content,
      'attachments': images,
      'level': level,
    };
    if (parentCommentId != null) {
      commentData['parentCommentId'] = parentCommentId;
    }
    final success = await orderProvider.addComment(commentData);
    if (success) {
      setState(() {
        _commentController.clear();
        _selectedImages.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send comment'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendReply(CommentModel comment) async {
    await _sendComment(
      content: _replyController.text.trim(),
      images: _replyImages,
      level: (_replyLevel ?? 1) + 1,
      parentCommentId: comment.id,
    );

    setState(() {
      _replyController.clear();
      _replyImages.clear();
      _replyingToId = null;
      _replyLevel = null;
    });
  }

  void _startReply(CommentModel comment, int currentLevel) {
    setState(() {
      _replyingToId = '${comment.id}';
      _replyLevel = currentLevel;
      _editingCommentId = null;
      _replyController.clear();
      _replyImages.clear();
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingToId = null;
      _replyLevel = null;
      _replyController.clear();
      _replyImages.clear();
    });
  }

  void _startEditComment(CommentModel comment) {
    setState(() {
      _editingCommentId = '${comment.id}';
      _replyingToId = null;
      _editController.text = comment.content;
      _editImages.clear();
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingCommentId = null;
      _editController.clear();
      _editImages.clear();
    });
  }

  Future<void> _saveEditComment(CommentModel comment) async {
    await editComment(
      comment.id,
      content: _editController.text.trim(),
      images: _editImages.isNotEmpty ? _editImages : null,
      orderId: widget.orderId,
    );

    setState(() {
      _editingCommentId = null;
      _editController.clear();
      _editImages.clear();
    });
  }

  Future<void> editComment(
    int commentId, {
    String? content,
    List<XFile>? images,
    int orderId = 0,
  }) async {
    if ((content == null || content.isEmpty) &&
        (images == null || images.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a message or select images'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final Map<String, dynamic> commentData = {};
    if (content != null && content.isNotEmpty) {
      commentData['content'] = content;
    }
    if (images != null && images.isNotEmpty) {
      commentData['attachments'] = images;
    }
    commentData['orderId'] = orderId;
    final success = await orderProvider.editComment(commentId, commentData);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to edit comment'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteComment(int commentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Comment'),
        content: Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.deleteComment(commentId);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete comment'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final comments = orderProvider.comments;
        final youId = Provider.of<AuthProvider>(
          context,
          listen: false,
        ).user?.id;

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Comment input box
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _commentController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Leave a comment...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                          ),
                        ),

                        if (_selectedImages.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Container(
                            height: 80.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(_selectedImages[index].path),
                                          width: 80.w,
                                          height: 80.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4.h,
                                        right: 4.w,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index),
                                          child: Container(
                                            padding: EdgeInsets.all(2.w),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _pickImages,
                              child: Icon(
                                Icons.image,
                                color: Colors.grey[600],
                                size: 24.h,
                              ),
                            ),

                            Spacer(),
                            GestureDetector(
                              onTap: () => _sendComment(
                                content: _commentController.text.trim(),
                                images: _selectedImages,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 16.h,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Send',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.h,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // List of comments
                  ...comments.asMap().entries.map((entry) {
                    final comment = entry.value;
                    return _buildCommentItem(comment, youId, 1);
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

  Widget _buildCommentItem(CommentModel comment, int? youId, int level) {
    final isYou = comment.userId == youId;
    final commentId = '${comment.id}';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 32.h,
                height: 32.h,
                decoration: BoxDecoration(
                  color: isYou ? Colors.blue : AppColors.buttonGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: comment.userAvatar.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            comment.userAvatar,
                            width: 32.h,
                            height: 32.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: SizedBox(
                                  width: 16.h,
                                  height: 16.h,
                                  child: CircularProgressIndicator(
                                    color: AppColors.buttonGreen,
                                    strokeWidth: 2,
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                comment.userName.isNotEmpty
                                    ? comment.userName[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  color: isYou ? Colors.white : Colors.black,
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          comment.userName.isNotEmpty
                              ? comment.userName[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            color: isYou ? Colors.white : Colors.black,
                            fontSize: 14.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.userName,
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Text(
                          comment.getTimeAgo(),
                          style: TextStyle(
                            fontSize: 12.h,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),

                    // Show edit form or comment content
                    if (_editingCommentId == commentId)
                      _buildEditForm(comment)
                    else
                      _buildCommentContent(comment, isYou, level),
                  ],
                ),
              ),
            ],
          ),

          // Reply form
          if (_editingCommentId != commentId && _replyingToId == commentId) ...[
            _buildReplyForm(comment),
          ],

          // Replies list
          if (comment.replies.isNotEmpty) ...[
            _buildRepliesList(comment.replies, youId, level),
          ],
        ],
      ),
    );
  }

  Widget _buildEditForm(CommentModel comment) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Column(
            children: [
              TextField(
                controller: _editController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Edit your comment...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
              ),

              // Edit images preview
              if (_editImages.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Container(
                  height: 60.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _editImages.length,
                    itemBuilder: (context, imgIndex) {
                      return Container(
                        margin: EdgeInsets.only(right: 8.w),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_editImages[imgIndex].path),
                                width: 60.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 2.h,
                              right: 2.w,
                              child: GestureDetector(
                                onTap: () => _removeEditImage(imgIndex),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 12.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],

              // Edit action buttons
              SizedBox(height: 8.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickEditImages,
                    child: Icon(Icons.image, color: Colors.orange, size: 20.h),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _cancelEdit,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12.h),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () => _saveEditComment(comment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      minimumSize: Size(0, 0),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 12.h),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentContent(CommentModel comment, bool isYou, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (comment.content.isNotEmpty) ...[
          Text(
            comment.content,
            style: TextStyle(fontSize: 14.h, color: Colors.black, height: 1.4),
          ),
        ],

        // Display images in comment
        if (comment.images.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Container(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: comment.images.length,
              itemBuilder: (context, imgIndex) {
                final imageUrl = comment.images[imgIndex];
                return Container(
                  margin: EdgeInsets.only(right: 8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.buttonGreen,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100.w,
                          height: 100.h,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],

        // Action buttons
        Row(
          children: [
            // Only show Reply button if level < 3
            if (level < 3)
              TextButton(
                onPressed: () => _startReply(comment, level),
                child: Text(
                  'Reply',
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (isYou) ...[
              TextButton(
                onPressed: () => _startEditComment(comment),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _deleteComment(comment.id),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildReplyForm(CommentModel comment) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 44.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            children: [
              // Reply text input
              TextField(
                controller: _replyController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
              ),

              // Reply images preview
              if (_replyImages.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Container(
                  height: 60.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _replyImages.length,
                    itemBuilder: (context, imgIndex) {
                      return Container(
                        margin: EdgeInsets.only(right: 8.w),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_replyImages[imgIndex].path),
                                width: 60.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 2.h,
                              right: 2.w,
                              child: GestureDetector(
                                onTap: () => _removeReplyImage(imgIndex),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 12.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],

              // Reply action buttons
              SizedBox(height: 8.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickReplyImages,
                    child: Icon(Icons.image, color: Colors.blue, size: 20.h),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _cancelReply,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12.h),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () => _sendReply(comment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      minimumSize: Size(0, 0),
                    ),
                    child: Text(
                      'Reply',
                      style: TextStyle(color: Colors.white, fontSize: 12.h),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRepliesList(
    List<CommentModel> replies,
    int? youId,
    int parentLevel,
  ) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 24.w),
          child: Column(
            children: replies.map<Widget>((reply) {
              return _buildCommentItem(reply, youId, parentLevel + 1);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
