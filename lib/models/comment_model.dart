class CommentModel {
  int id;
  int userId;
  String userName;
  String userAvatar;
  String content;
  int level;
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
    this.level = 1,
    this.images = const [],
    this.replies = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      userId: json['commenter']['id'] ?? 0,
      level: json['level'] ?? 1,
      userName: json['commenter']['businessName'] ?? "",
      userAvatar: json['commenter']['avatar'] ?? "",
      content: json['content'] ?? "",
      images: List<String>.from(json['attachments'] ?? []),
      replies:
          (json['subComments'] as List<dynamic>?)
              ?.map((reply) => CommentModel.fromJson(reply))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdTime']),
      updatedAt: DateTime.parse(json['modifiedTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'images': images,
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
