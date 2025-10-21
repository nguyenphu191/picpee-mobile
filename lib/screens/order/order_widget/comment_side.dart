import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/comment_model.dart';
import 'package:picpee_mobile/providers/auth_provider.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:picpee_mobile/providers/user_provider.dart';
import 'package:picpee_mobile/services/upload_service.dart';
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
  final UploadService _uploadService = UploadService();

  XFile? _selectedImage;
  final TextEditingController _replyController = TextEditingController();

  final TextEditingController _editController = TextEditingController();
  XFile? _editImage;
  String? _existingEditImage;

  String? _editingCommentId;
  String? _replyingToId;
  int? _replyLevel;

  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadStatus = '';

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

  // Overlay SnackBar method (same as AddOrderCard)
  void _showOverlaySnackBar(
    String message, {
    Color backgroundColor = Colors.red,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.h,
        left: 16.w,
        right: 16.w,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.h,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(Duration(seconds: 2), () {
      entry.remove();
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> fetchComment() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.fetchOrderComments(widget.orderId);
    if (!success && mounted) {
      _showOverlaySnackBar(
        'Failed to load comments',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
        _uploadStatus = 'Uploading image...';
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      final file = File(image.path);

      final url = await _uploadService.uploadOrderCommentImage(
        file: file,
        token: token,
        onUploadProgress: (sent, total) {
          setState(() {
            _uploadProgress = sent / total;
          });
        },
      );

      setState(() {
        _isUploading = false;
        _uploadProgress = 1.0;
        _uploadStatus = 'Upload complete!';
      });

      return url;
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
        _uploadStatus = '';
      });

      if (mounted) {
        _showOverlaySnackBar(
          'Failed to upload image: ${e.toString()}',
          backgroundColor: Colors.red,
        );
      }

      return null;
    }
  }

  Future<void> _sendComment({
    required String content,
    XFile? image,
    int level = 1,
    int? parentCommentId,
  }) async {
    if (content.isEmpty && image == null) {
      _showOverlaySnackBar(
        'Please enter a message or select an image',
        backgroundColor: Colors.red,
      );
      return;
    }

    // Upload image first if exists
    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImage(image);
      if (imageUrl == null) {
        // Upload failed
        if (mounted) {
          _showOverlaySnackBar(
            'Failed to upload image. Please try again.',
            backgroundColor: Colors.red,
          );
        }
        return;
      }
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final Map<String, dynamic> commentData = {
      'orderId': widget.orderId,
      'content': content,
      'level': level,
    };

    if (imageUrl != null) {
      commentData['attachments'] = [imageUrl];
    }

    if (parentCommentId != null) {
      commentData['parentCommentId'] = parentCommentId;
    }

    final success = await orderProvider.addComment(commentData);

    if (success) {
      setState(() {
        _commentController.clear();
        _selectedImage = null;
      });

      if (mounted) {
        _showOverlaySnackBar(
          'Comment sent successfully',
          backgroundColor: Colors.green,
        );
      }
    } else {
      if (mounted) {
        _showOverlaySnackBar(
          'Failed to send comment',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _sendReply(CommentModel comment) async {
    await _sendComment(
      content: _replyController.text.trim(),
      image: null, // No images in replies
      level: (_replyLevel ?? 1) + 1,
      parentCommentId: comment.id,
    );

    setState(() {
      _replyController.clear();
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
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingToId = null;
      _replyLevel = null;
      _replyController.clear();
    });
  }

  void _startEditComment(CommentModel comment) {
    setState(() {
      _editingCommentId = '${comment.id}';
      _replyingToId = null;
      _editController.text = comment.content;
      _editImage = null;
      _existingEditImage = comment.images.isNotEmpty
          ? comment.images.first
          : null;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingCommentId = null;
      _editController.clear();
      _editImage = null;
      _existingEditImage = null;
    });
  }

  Future<void> _saveEditComment(CommentModel comment) async {
    await editComment(
      comment.id,
      content: _editController.text.trim(),
      newImage: _editImage,
      existingImage: _existingEditImage,
      orderId: widget.orderId,
    );

    setState(() {
      _editingCommentId = null;
      _editController.clear();
      _editImage = null;
      _existingEditImage = null;
    });
  }

  Future<void> editComment(
    int commentId, {
    String? content,
    XFile? newImage,
    String? existingImage,
    int orderId = 0,
  }) async {
    if ((content == null || content.isEmpty) &&
        newImage == null &&
        existingImage == null) {
      _showOverlaySnackBar(
        'Please enter a message or select an image',
        backgroundColor: Colors.red,
      );
      return;
    }

    // Upload new image if exists
    String? newImageUrl;
    if (newImage != null) {
      newImageUrl = await _uploadImage(newImage);
      if (newImageUrl == null) {
        if (mounted) {
          _showOverlaySnackBar(
            'Failed to upload image. Please try again.',
            backgroundColor: Colors.red,
          );
        }
        return;
      }
    }

    // Determine final image: new image takes priority over existing
    String? finalImageUrl;
    if (newImageUrl != null) {
      finalImageUrl = newImageUrl;
    } else if (existingImage != null) {
      finalImageUrl = existingImage;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final Map<String, dynamic> commentData = {'orderId': orderId};

    if (content != null && content.isNotEmpty) {
      commentData['content'] = content;
    }

    if (finalImageUrl != null) {
      commentData['attachments'] = [finalImageUrl];
    }

    final success = await orderProvider.editComment(commentId, commentData);

    if (success) {
      if (mounted) {
        _showOverlaySnackBar(
          'Comment updated successfully',
          backgroundColor: Colors.green,
        );
      }
    } else {
      if (mounted) {
        _showOverlaySnackBar(
          'Failed to edit comment',
          backgroundColor: Colors.red,
        );
      }
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

    if (success) {
      if (mounted) {
        _showOverlaySnackBar(
          'Comment deleted successfully',
          backgroundColor: Colors.green,
        );
      }
    } else {
      if (mounted) {
        _showOverlaySnackBar(
          'Failed to delete comment',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void _showFullScreenImage(
    BuildContext context,
    String imageUrl,
    List<String> allImages,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.white, size: 48.h),
                          SizedBox(height: 8.h),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 40.h,
              right: 16.w,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 32.h),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final comments = orderProvider.comments;
        final youId = Provider.of<UserProvider>(
          context,
          listen: false,
        ).user?.id;

        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                            enabled: !_isUploading,
                            decoration: InputDecoration(
                              hintText: 'Leave a comment...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none,
                            ),
                          ),

                          if (_selectedImage != null) ...[
                            SizedBox(height: 8.h),
                            Container(
                              height: 80.h,
                              width: 80.w,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      width: 80.w,
                                      height: 80.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (!_isUploading)
                                    Positioned(
                                      top: 4.h,
                                      right: 4.w,
                                      child: GestureDetector(
                                        onTap: _removeImage,
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
                            ),
                          ],

                          // Upload progress
                          if (_isUploading) ...[
                            SizedBox(height: 8.h),
                            Column(
                              children: [
                                LinearProgressIndicator(
                                  value: _uploadProgress,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.buttonGreen,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _uploadStatus,
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],

                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _isUploading || _selectedImage != null
                                    ? null
                                    : _pickImage,
                                child: Icon(
                                  Icons.image,
                                  color:
                                      (_isUploading || _selectedImage != null)
                                      ? Colors.grey[400]
                                      : Colors.red,
                                  size: 24.h,
                                ),
                              ),

                              Spacer(),
                              GestureDetector(
                                onTap: _isUploading
                                    ? null
                                    : () => _sendComment(
                                        content: _commentController.text.trim(),
                                        image: _selectedImage,
                                      ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isUploading
                                        ? Colors.grey[400]
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_isUploading)
                                        SizedBox(
                                          width: 16.w,
                                          height: 16.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      else
                                        Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 16.h,
                                        ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        _isUploading ? 'Uploading...' : 'Send',
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

                    // Empty state
                    if (comments.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 64.h,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  fontSize: 16.h,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Be the first to comment',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // List of comments
                      ...comments.asMap().entries.map((entry) {
                        final comment = entry.value;
                        return _buildCommentItem(comment, youId, 1);
                      }).toList(),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (orderProvider.loading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
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
                        SizedBox(height: 12.h),
                        Text(
                          "Loading comments...",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
                enabled: !_isUploading,
                decoration: InputDecoration(
                  hintText: 'Edit your comment...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
              ),

              if (_existingEditImage != null && _editImage == null) ...[
                SizedBox(height: 8.h),

                Container(
                  width: 80.w,
                  height: 80.h,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _existingEditImage!,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Edit action buttons
              SizedBox(height: 8.h),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: _isUploading ? null : _cancelEdit,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12.h),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () => _saveEditComment(comment),
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

        if (comment.images.isNotEmpty) ...[
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: () => _showFullScreenImage(
              context,
              comment.images.first,
              comment.images,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                comment.images.first,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 120.w,
                    height: 120.h,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonGreen,
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120.w,
                    height: 120.h,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 32.h,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Failed to load',
                          style: TextStyle(
                            fontSize: 10.h,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
              comment.images.isEmpty
                  ? TextButton(
                      onPressed: () => _startEditComment(comment),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 14.h,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
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
        SizedBox(height: 8.h),
        Container(
          margin: EdgeInsets.only(left: 44.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                enabled: !_isUploading,
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
              ),

              // Reply action buttons
              SizedBox(height: 8.h),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: _isUploading ? null : _cancelReply,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12.h),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: _isUploading ? null : () => _sendReply(comment),
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
