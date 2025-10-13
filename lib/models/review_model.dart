class ReviewModel {
  final int id;
  final Reviewer reviewer;
  final int rating;
  final String comment;
  final int numberEdit;
  final int numberOrder;
  final int createdTime;
  final int modifiedTime;

  ReviewModel({
    required this.id,
    required this.reviewer,
    required this.rating,
    required this.comment,
    required this.numberEdit,
    required this.numberOrder,
    required this.createdTime,
    required this.modifiedTime,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      reviewer: Reviewer.fromJson(json['reviewer'] ?? {}),
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      numberEdit: json['numberEdit'] ?? 0,
      numberOrder: json['numberOrder'] ?? 0,
      createdTime: json['createdTime'] ?? 0,
      modifiedTime: json['modifiedTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewer': reviewer.toJson(),
      'rating': rating,
      'comment': comment,
      'numberEdit': numberEdit,
      'numberOrder': numberOrder,
      'createdTime': createdTime,
      'modifiedTime': modifiedTime,
    };
  }
}

class Reviewer {
  final int id;
  final String businessName;
  final String avatar;

  Reviewer({
    required this.id,
    required this.businessName,
    required this.avatar,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] ?? 0,
      businessName: json['businessName'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'avatar': avatar, 'businessName': businessName};
  }
}
