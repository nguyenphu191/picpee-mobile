import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart'; // Thêm import
import 'dart:io'; // Thêm import
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/core/utils/mock_order_data.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  final order = MockOrderData.getAllOrders()[8];
  late TabController _fileTabController;
  late TabController _bottomTabController;
  late TabController _drawerTabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // Thêm ImagePicker
  List<XFile> _selectedImages = []; // Thay đổi type thành XFile
  List<bool> _checklistStates = [];

  // Thêm biến cho reply
  int? _replyingToIndex;
  final TextEditingController _replyController = TextEditingController();
  List<XFile> _replyImages = [];

  // Thêm biến cho edit comment
  int? _editingCommentIndex;
  final TextEditingController _editController = TextEditingController();
  List<XFile> _editImages = [];

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  List<Map<String, dynamic>> mockActivities = [
    {'time': '2 hours ago', 'description': 'Order created by client'},
    {
      'time': '1 hour ago',
      'description': 'Designer John Doe submitted initial draft',
    },
    {
      'time': '30 minutes ago',
      'description': 'Client requested revision on color scheme',
    },
    {
      'time': '10 minutes ago',
      'description': 'Designer John Doe uploaded revised draft',
    },
  ];

  List<Map<String, dynamic>> sourceFiles = [
    {'name': 'source_file_1.psd', 'size': '2.5 MB', 'icon': Icons.image},
    {
      'name': 'source_file_2.ai',
      'size': '1.8 MB',
      'icon': Icons.design_services,
    },
    {'name': 'source_file_3.sketch', 'size': '3.2 MB', 'icon': Icons.brush},
  ];

  List<Map<String, dynamic>> finishedFiles = [
    {'name': 'final_design_1.png', 'size': '1.2 MB', 'icon': Icons.image},
    {'name': 'final_design_2.jpg', 'size': '0.8 MB', 'icon': Icons.image},
    {
      'name': 'final_design_3.pdf',
      'size': '0.5 MB',
      'icon': Icons.picture_as_pdf,
    },
  ];

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

  @override
  void initState() {
    super.initState();
    _fileTabController = TabController(length: 2, vsync: this);
    _bottomTabController = TabController(length: 2, vsync: this);
    _drawerTabController = TabController(length: 2, vsync: this);

    // Khởi tạo tất cả checkbox là true (đã tích)
    _checklistStates = List.generate(order.checklist.length, (index) => true);
  }

  @override
  void dispose() {
    _fileTabController.dispose();
    _bottomTabController.dispose();
    _drawerTabController.dispose();
    _commentController.dispose();
    _replyController.dispose();
    _editController.dispose(); // Dispose edit controller
    super.dispose();
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
      // Hiển thị error message nếu cần
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

  // Hàm gửi comment
  void _sendComment() {
    if (_commentController.text.trim().isNotEmpty ||
        _selectedImages.isNotEmpty) {
      setState(() {
        comments.add({
          'user': 'You',
          'avatar': 'Y',
          'time': 'now',
          'message': _commentController.text.trim(),
          'images': _selectedImages.map((image) => image.path).toList(),
          'replies': [], // Thêm danh sách replies
        });
        _commentController.clear();
        _selectedImages.clear();
      });
    }
  }

  // Hàm gửi reply
  void _sendReply(int commentIndex) {
    if (_replyController.text.trim().isNotEmpty || _replyImages.isNotEmpty) {
      setState(() {
        if (comments[commentIndex]['replies'] == null) {
          comments[commentIndex]['replies'] = [];
        }
        comments[commentIndex]['replies'].add({
          'user': 'You',
          'avatar': 'Y',
          'time': 'now',
          'message': _replyController.text.trim(),
          'images': _replyImages.map((image) => image.path).toList(),
        });
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
      // Load existing images nếu có
      if (comment['images'] != null) {
        // Trong thực tế, bạn có thể cần convert từ path sang XFile
        // Ở đây tôi để trống vì đã có images trong comment
      }
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
      setState(() {
        comments[commentIndex]['message'] = _editController.text.trim();
        // Cập nhật images nếu có thay đổi
        if (_editImages.isNotEmpty) {
          comments[commentIndex]['images'] = _editImages
              .map((image) => image.path)
              .toList();
        }
        comments[commentIndex]['time'] = 'edited';
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

  // Hàm xóa hình ảnh edit
  void _removeEditImage(int index) {
    setState(() {
      _editImages.removeAt(index);
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
                setState(() {
                  comments.removeAt(commentIndex);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentsList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Comment input với hình ảnh (giữ nguyên)
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                // Text input
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Leave a comment...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                  ),
                ),

                // Selected images preview
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

                // Action buttons
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
                    SizedBox(width: 16.w),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Icon(
                        Icons.attach_file,
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

          // Comments list
          ...comments.asMap().entries.map((entry) {
            final index = entry.key;
            final comment = entry.value;
            return Container(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  // Main comment
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
                              color: Colors.white,
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
                                SizedBox(width: 8.w),
                                Text(
                                  'commented',
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    color: Colors.grey[600],
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
                              // Edit form
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange[200]!,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _editController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: 'Edit your comment...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
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
                                              margin: EdgeInsets.only(
                                                right: 8.w,
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: Image.file(
                                                      File(
                                                        _editImages[imgIndex]
                                                            .path,
                                                      ),
                                                      width: 60.w,
                                                      height: 60.h,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 2.h,
                                                    right: 2.w,
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _removeEditImage(
                                                            imgIndex,
                                                          ),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                          2.w,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape
                                                                  .circle,
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
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.orange,
                                            size: 20.h,
                                          ),
                                        ),
                                        Spacer(),
                                        TextButton(
                                          onPressed: _cancelEdit,
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12.h,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        ElevatedButton(
                                          onPressed: () =>
                                              _saveEditComment(index),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 6.h,
                                            ),
                                            minimumSize: Size(0, 0),
                                          ),
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.h,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              // Normal comment display
                              if (comment['message'].isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  comment['message'],
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    color: Colors.black,
                                  ),
                                ),
                              ],

                              // Hiển thị hình ảnh trong comment
                              if (comment['images'] != null &&
                                  comment['images'].isNotEmpty) ...[
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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

                              SizedBox(height: 8.h),
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
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Reply input (chỉ hiển thị khi không đang edit và đang reply)
                  if (_editingCommentIndex != index &&
                      _replyingToIndex == index) ...[
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                            onTap: () =>
                                                _removeReplyImage(imgIndex),
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
                                child: Icon(
                                  Icons.image,
                                  color: Colors.blue,
                                  size: 20.h,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: _cancelReply,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12.h,
                                  ),
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Hiển thị replies (giữ nguyên)
                  if (comment['replies'] != null &&
                      comment['replies'].isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Container(
                      margin: EdgeInsets.only(left: 44.w),
                      child: Column(
                        children: comment['replies'].map<Widget>((reply) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                margin: EdgeInsets.only(
                                                  right: 4.w,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  child: Image.file(
                                                    File(
                                                      reply['images'][imgIndex],
                                                    ),
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
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildChecklistTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value:
                            _checklistStates
                                .where((checked) => checked)
                                .length /
                            _checklistStates.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '${_checklistStates.where((checked) => checked).length}/${_checklistStates.length}',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Checklist items
          ...order.checklist.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Checkbox(
                    value: _checklistStates[index],
                    onChanged: (value) {
                      setState(() {
                        _checklistStates[index] = value ?? false;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black,
                        decoration: _checklistStates[index]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          // Action buttons
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _checklistStates = List.generate(
                        _checklistStates.length,
                        (index) => true,
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Check All',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _checklistStates = List.generate(
                        _checklistStates.length,
                        (index) => false,
                      );
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: Text(
                    'Uncheck All',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Thêm key cho Scaffold
      backgroundColor: Colors.white,
      endDrawer: _buildEndDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service info
                  Row(
                    children: [
                      Image.asset(
                        order.getServiceImg(),
                        width: 40.h,
                        height: 40.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        order.serviceName,
                        style: TextStyle(
                          fontSize: 18.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Status and menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: order.getStatusColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              order.getStatusIcon(),
                              color: order.getStatusColor(),
                              size: 18.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              order.status.displayName,
                              style: TextStyle(
                                fontSize: 14.h,
                                fontWeight: FontWeight.bold,
                                color: order.getStatusColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          switch (value) {
                            case 'comment':
                              _drawerTabController.animateTo(0);
                              _scaffoldKey.currentState
                                  ?.openEndDrawer(); // Sử dụng GlobalKey
                              break;
                            case 'checklist':
                              _drawerTabController.animateTo(1);
                              _scaffoldKey.currentState
                                  ?.openEndDrawer(); // Sử dụng GlobalKey
                              break;
                            case 'edit':
                              // Xử lý edit
                              break;
                            case 'delete':
                              // Xử lý delete
                              break;
                            case 'completed':
                              // Xử lý completed
                              break;
                            case 'revisions':
                              // Xử lý revisions
                              break;
                            case 'dispute':
                              // Xử lý dispute
                              break;
                          }
                        },
                        offset: Offset(
                          -120,
                          30,
                        ), // Sửa lại offset để menu hiển thị đúng vị trí
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'comment',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  size: 20.h,
                                  color: Colors.grey[700],
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Comment',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'checklist',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.checklist,
                                  size: 20.h,
                                  color: Colors.grey[700],
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Checklist',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'completed',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 20.h,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Mark Completed',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'revisions',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.restore,
                                  size: 20.h,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Request for Revisions',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'dispute',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.gavel,
                                  size: 20.h,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Dispute Order',
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        child: Icon(
                          Icons.more_vert,
                          size: 24.h,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Designer and total info
                  Row(
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.buttonGreen,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: order.designerAvatar != ""
                            ? Image.network(
                                order.designerAvatar,
                                fit: BoxFit.cover,
                              )
                            : Text(
                                'N',
                                style: TextStyle(
                                  fontSize: 24.h,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Designer',
                              style: TextStyle(
                                fontSize: 16.h,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${order.designerName}',
                              style: TextStyle(
                                fontSize: 16.h,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16.h,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '\$${order.total}',
                            style: TextStyle(
                              fontSize: 16.h,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Dates
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Submitted',
                            style: TextStyle(
                              fontSize: 16.h,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatDate(order.submitted),
                            style: TextStyle(
                              fontSize: 12.h,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due Date',
                            style: TextStyle(
                              fontSize: 16.h,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatDate(order.dueDate),
                            style: TextStyle(
                              fontSize: 12.h,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Activity section
                  Text(
                    'Activity',
                    style: TextStyle(
                      fontSize: 14.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Divider(),
                  Container(
                    constraints: BoxConstraints(maxHeight: 200.h),
                    child: ListView.builder(
                      itemCount: mockActivities.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final activity = mockActivities[index];
                        return Container(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8.h,
                                height: 8.h,
                                margin: EdgeInsets.only(top: 6.h, right: 12.w),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity['description'],
                                      style: TextStyle(
                                        fontSize: 14.h,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      activity['time'],
                                      style: TextStyle(
                                        fontSize: 12.h,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 16.h),

                  // Files TabBar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: _fileTabController,
                      isScrollable: true, // Thêm dòng này
                      tabAlignment: TabAlignment.start, // Thêm dòng này
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[600],
                      labelStyle: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(text: "Source Files"),
                        Tab(text: "Finished Files"),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Files content
                  Container(
                    height: 200.h,
                    child: TabBarView(
                      controller: _fileTabController,
                      children: [
                        _buildFileList(sourceFiles),
                        _buildFileList(finishedFiles),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: "Overview"),
          ),
        ],
      ),
    );
  }

  Widget _buildEndDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85, // 85% của màn hình
      child: Column(
        children: [
          // Header
          Container(
            height: 80.h,
            padding: EdgeInsets.only(top: 40.h, left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, size: 24.h),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 18.h,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // TabBar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16.w),
            child: TabBar(
              controller: _drawerTabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: TextStyle(
                fontSize: 14.h,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Comments"),
                      SizedBox(width: 4.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${comments.length}',
                          style: TextStyle(color: Colors.white, fontSize: 12.h),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(text: "Checklist"),
              ],
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _drawerTabController,
              children: [
                // Comments Tab
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildCommentsList(),
                ),
                // Checklist Tab
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildChecklistTab(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileList(List<Map<String, dynamic>> files) {
    return Column(
      // Thay ListView.builder bằng Column
      children: files
          .map(
            (file) => Container(
              // Sử dụng map thay vì itemBuilder
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              child: Row(
                children: [
                  Icon(Icons.image, color: Colors.blue, size: 24.h),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      file['name'],
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.download,
                      color: Colors.grey[600],
                      size: 20.h,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(), // Chuyển đổi map thành list
    );
  }

  // ...existing code...
}
