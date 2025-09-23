class CommentModel {
  String id;
  String userId;
  String userName;
  String userAvatar;
  String content;
  List<String> images;
  List<CommentModel> replies;
  DateTime createdAt;
  DateTime updatedAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.images = const [],
    this.replies = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      content: json['content'],
      images: List<String>.from(json['images'] ?? []),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((reply) => CommentModel.fromJson(reply))
          .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'images': images,
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper methods
  bool get isOwnComment => userId == 'current_user_id'; 
  String get displayTime {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  bool get isEdited => updatedAt.isAfter(createdAt);
}
