class Comment {
  final String id;
  final String content;
  final DateTime createdAt;
  final String authorName;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.authorName,
  });
}

class Ticket {
  final String id;
  final String title;
  final String details;
  final String type;
  final String imgUrl;
  final DateTime createdAt;
  final String status;
  final List<Comment> comments;

  Ticket({
    required this.id,
    required this.title,
    required this.details,
    required this.type,
    required this.createdAt,
    required this.status,
    this.imgUrl = '',
    this.comments = const [],
  });

  Ticket copyWith({
    String? id,
    String? title,
    String? details,
    String? type,
    String? imgUrl,
    DateTime? createdAt,
    String? status,
    List<Comment>? comments,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      type: type ?? this.type,
      imgUrl: imgUrl ?? this.imgUrl,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      comments: comments ?? this.comments,
    );
  }
}