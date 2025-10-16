class CommentModel {
  int id;
  int userId;
  String userName;
  String userAvatar;
  String content;
  int level;
  int? parentCommentId;
  List<String> images;
  List<CommentModel> replies;
  int createdAt;
  int updatedAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.level = 1,
    this.parentCommentId,
    this.images = const [],
    this.replies = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // Parse replies recursively
    List<CommentModel> parseReplies(List<dynamic>? subComments) {
      if (subComments == null || subComments.isEmpty) {
        return [];
      }
      return subComments
          .map((reply) => CommentModel.fromJson(reply as Map<String, dynamic>))
          .toList();
    }

    return CommentModel(
      id: json['id'] ?? 0,
      userId: json['commenter']?['id'] ?? 0,
      level: json['level'] ?? 1,
      parentCommentId: json['parentCommentId'],
      userName:
          json['commenter']?['businessName'] ??
          json['commenter']?['firstname'] ??
          json['commenter']?['username'] ??
          "Unknown",
      userAvatar: json['commenter']?['avatar'] ?? "",
      content: json['content'] ?? "",
      images:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      replies: parseReplies(json['subComments'] as List<dynamic>?),
      createdAt: json['createdTime'] ?? 0,
      updatedAt: json['modifiedTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'level': level,
      'parentCommentId': parentCommentId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'images': images,
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Trả về dạng theo số ngày: 44d
  String getTimeAgo() {
    if (createdAt == 0) {
      return "";
    }

    // Convert từ UTC sang giờ local
    final utcDate = DateTime.fromMillisecondsSinceEpoch(createdAt, isUtc: true);
    final localDate = utcDate.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} d';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months months';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years y';
    }
  }

  // Helper method để lấy tất cả replies (flatten)
  List<CommentModel> getAllReplies() {
    List<CommentModel> allReplies = [];
    for (var reply in replies) {
      allReplies.add(reply);
      allReplies.addAll(reply.getAllReplies());
    }
    return allReplies;
  }

  // Helper method để đếm tổng số replies
  int getTotalRepliesCount() {
    int count = replies.length;
    for (var reply in replies) {
      count += reply.getTotalRepliesCount();
    }
    return count;
  }

  // Helper method để tìm comment theo ID
  CommentModel? findCommentById(int searchId) {
    if (id == searchId) return this;

    for (var reply in replies) {
      final found = reply.findCommentById(searchId);
      if (found != null) return found;
    }

    return null;
  }
}
