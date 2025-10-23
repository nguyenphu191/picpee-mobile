class ReviewModel {
  int id;
  Reviewer reviewer;
  Reviewer? doer;
  int rating;
  String comment;
  int numberEdit;
  int numberOrder;
  int createdTime;
  int modifiedTime;

  ReviewModel({
    required this.id,
    required this.reviewer,
    this.doer,
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
      doer: json['doer'] != null ? Reviewer.fromJson(json['doer']) : null,
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
  int id;
  String businessName;
  String avatar;
  bool rated = false;

  Reviewer({
    required this.id,
    required this.businessName,
    required this.avatar,
    required this.rated,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] ?? 0,
      businessName: json['businessName'] ?? '',
      avatar: json['avatar'] ?? '',
      rated: json['rated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'avatar': avatar, 'businessName': businessName};
  }
}
