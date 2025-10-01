import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:picpee_mobile/core/theme/app_colors.dart';

class CommentSide extends StatefulWidget {
  const CommentSide({super.key});

  @override
  State<CommentSide> createState() => _CommentSideState();
}

class _CommentSideState extends State<CommentSide> {
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  List<Map<String, dynamic>> comments = [
    {
      'user': 'Anders',
      'avatar': 'A',
      'time': '4h',
      'message':
          'Disputed the order with the reason: Designers sometimes clash with the projects vision, leading to frustration.',
    },
    {'user': 'Anders', 'avatar': 'A', 'time': '4h', 'message': 'sd'},
  ];

  // Reply variables
  int? _replyingToIndex;
  final TextEditingController _replyController = TextEditingController();
  List<XFile> _replyImages = [];

  // Edit comment variables
  int? _editingCommentIndex;
  final TextEditingController _editController = TextEditingController();
  List<XFile> _editImages = [];
  // Callback functions for comments
  void _onSendComment(Map<String, dynamic> commentData) {
    setState(() {
      comments.add(commentData);
    });
  }

  void _onSendReply(int commentIndex, Map<String, dynamic> replyData) {
    setState(() {
      if (comments[commentIndex]['replies'] == null) {
        comments[commentIndex]['replies'] = [];
      }
      comments[commentIndex]['replies'].add(replyData);
    });
  }

  void _onEditComment(int commentIndex, Map<String, dynamic> editedData) {
    setState(() {
      comments[commentIndex]['message'] = editedData['message'];
      if (editedData['images'].isNotEmpty) {
        comments[commentIndex]['images'] = editedData['images'];
      }
      comments[commentIndex]['time'] = editedData['time'];
    });
  }

  void _onDeleteComment(int commentIndex) {
    setState(() {
      comments.removeAt(commentIndex);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _replyController.dispose();
    _editController.dispose();
    super.dispose();
  }

  // Hàm chọn hình ảnh thật từ máy
  void _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting images')));
    }
  }

  // Hàm chọn ảnh cho reply
  void _pickReplyImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _replyImages.addAll(images);
        });
      }
    } catch (e) {
      print('Error picking reply images: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting images')));
    }
  }

  // Hàm chọn ảnh cho edit
  void _pickEditImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _editImages.addAll(images);
        });
      }
    } catch (e) {
      print('Error picking edit images: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting images')));
    }
  }

  // Hàm gửi comment
  void _sendComment() {
    if (_commentController.text.trim().isNotEmpty ||
        _selectedImages.isNotEmpty) {
      final commentData = {
        'user': 'You',
        'avatar': 'Y',
        'time': 'now',
        'message': _commentController.text.trim(),
        'images': _selectedImages.map((image) => image.path).toList(),
        'replies': [],
      };

      _onSendComment(commentData);

      setState(() {
        _commentController.clear();
        _selectedImages.clear();
      });
    }
  }

  // Hàm bắt đầu reply
  void _startReply(int commentIndex) {
    setState(() {
      _replyingToIndex = commentIndex;
      _replyController.clear();
      _replyImages.clear();
    });
  }

  // Hàm hủy reply
  void _cancelReply() {
    setState(() {
      _replyingToIndex = null;
      _replyController.clear();
      _replyImages.clear();
    });
  }

  // Hàm gửi reply
  void _sendReply(int commentIndex) {
    if (_replyController.text.trim().isNotEmpty || _replyImages.isNotEmpty) {
      final replyData = {
        'user': 'You',
        'avatar': 'Y',
        'time': 'now',
        'message': _replyController.text.trim(),
        'images': _replyImages.map((image) => image.path).toList(),
      };

      _onSendReply(commentIndex, replyData);

      setState(() {
        _replyController.clear();
        _replyImages.clear();
        _replyingToIndex = null;
      });
    }
  }

  // Hàm bắt đầu edit comment
  void _startEditComment(int commentIndex) {
    final comment = comments[commentIndex];
    setState(() {
      _editingCommentIndex = commentIndex;
      _editController.text = comment['message'];
      _editImages.clear();
    });
  }

  // Hàm hủy edit
  void _cancelEdit() {
    setState(() {
      _editingCommentIndex = null;
      _editController.clear();
      _editImages.clear();
    });
  }

  // Hàm lưu edit comment
  void _saveEditComment(int commentIndex) {
    if (_editController.text.trim().isNotEmpty) {
      final editedCommentData = {
        'message': _editController.text.trim(),
        'images': _editImages.map((image) => image.path).toList(),
        'time': 'edited',
      };

      _onEditComment(commentIndex, editedCommentData);

      setState(() {
        _editingCommentIndex = null;
        _editController.clear();
        _editImages.clear();
      });
    }
  }

  // Hàm xóa hình ảnh đã chọn
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // Hàm xóa hình ảnh reply
  void _removeReplyImage(int index) {
    setState(() {
      _replyImages.removeAt(index);
    });
  }



  // Hàm xóa comment với confirmation dialog
  void _deleteComment(int commentIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Comment'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _onDeleteComment(commentIndex);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                      onTap: _sendComment,
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
                            Icon(Icons.send, color: Colors.white, size: 16.h),
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
            final index = entry.key;
            final comment = entry.value;
            return Container(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32.h,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: comment['user'] == 'You'
                              ? Colors.blue
                              : AppColors.buttonGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            comment['avatar'],
                            style: TextStyle(
                              color: comment['user'] == 'You'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14.h,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment['user'],
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                Spacer(),
                                Text(
                                  comment['time'],
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    color: Colors.grey[600],
                                    fontStyle: comment['time'] == 'edited'
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),

                            // Hiển thị comment content hoặc edit form
                            if (_editingCommentIndex == index) ...[
                              _buildEditForm(index),
                            ] else ...[
                              _buildCommentContent(comment, index),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (_editingCommentIndex != index &&
                      _replyingToIndex == index) ...[
                    _buildReplyForm(index),
                  ],

                  if (comment['replies'] != null &&
                      comment['replies'].isNotEmpty) ...[
                    _buildRepliesList(comment['replies']),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEditForm(int index) {
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

              // Edit action buttons
              SizedBox(height: 8.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickEditImages,
                    child: Icon(Icons.image, color: Colors.red, size: 20.h),
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
                    onPressed: () => _saveEditComment(index),
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

  Widget _buildCommentContent(Map<String, dynamic> comment, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (comment['message'].isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            comment['message'],
            style: TextStyle(fontSize: 14.h, color: Colors.black),
          ),
        ],

        // Hiển thị hình ảnh trong comment
        if (comment['images'] != null && comment['images'].isNotEmpty) ...[
          SizedBox(height: 8.h),
          Container(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: comment['images'].length,
              itemBuilder: (context, imgIndex) {
                return Container(
                  margin: EdgeInsets.only(right: 8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(comment['images'][imgIndex]),
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],

        Row(
          children: [
            TextButton(
              onPressed: () => _startReply(index),
              child: Text(
                'Reply',
                style: TextStyle(
                  fontSize: 12.h,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (comment['user'] == 'You') ...[
              TextButton(
                onPressed: () => _startEditComment(index),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12.h,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _deleteComment(index),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 12.h,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildReplyForm(int index) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.only(left: 44.w),
          padding: EdgeInsets.all(12.w),
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
                    onPressed: () => _sendReply(index),
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

  Widget _buildRepliesList(List<dynamic> replies) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          margin: EdgeInsets.only(left: 44.w),
          child: Column(
            children: replies.map<Widget>((reply) {
              return Container(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.h,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: reply['user'] == 'You'
                            ? Colors.blue
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          reply['avatar'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                reply['user'],
                                style: TextStyle(
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                reply['time'],
                                style: TextStyle(
                                  fontSize: 10.h,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          if (reply['message'].isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              reply['message'],
                              style: TextStyle(
                                fontSize: 12.h,
                                color: Colors.black,
                              ),
                            ),
                          ],

                          // Reply images
                          if (reply['images'] != null &&
                              reply['images'].isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Container(
                              height: 60.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: reply['images'].length,
                                itemBuilder: (context, imgIndex) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 4.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.file(
                                        File(reply['images'][imgIndex]),
                                        width: 60.w,
                                        height: 60.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
