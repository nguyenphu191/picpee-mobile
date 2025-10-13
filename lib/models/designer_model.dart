import 'dart:ui';

import 'package:flutter/material.dart';

class DesignerModel {
  final int userId;
  final String code;
  final String lastname;
  final String firstname;
  final String email;
  final String businessName;
  final String avatar;
  final String countryCode;
  final String countryName;
  final String statusUser;
  final String statusReceiveOrder;
  final String imageFlag;
  final String imageCover;
  final int skillId;
  final String skillName;
  final String category;
  final int turnaroundTime;
  final double cost;
  final String imageSkill;
  final double ratingPoint;
  final int totalReview;
  final int userSkillId;
  final int totalFavorite;
  final bool statusFavorite;
  final bool verified;
  final String timezone;

  DesignerModel({
    required this.userId,
    required this.code,
    required this.email,
    required this.lastname,
    required this.firstname,
    required this.businessName,
    required this.avatar,
    required this.countryCode,
    required this.statusUser,
    required this.statusReceiveOrder,
    required this.imageFlag,
    required this.imageCover,
    required this.skillId,
    required this.skillName,
    required this.category,
    required this.turnaroundTime,
    required this.cost,
    required this.imageSkill,
    required this.ratingPoint,
    required this.totalReview,
    required this.userSkillId,
    required this.totalFavorite,
    required this.statusFavorite,
    required this.verified,
    required this.timezone,
    required this.countryName,
  });

  factory DesignerModel.fromJson(Map<String, dynamic> json) {
    return DesignerModel(
      userId: json['userId'] ?? 0,
      email: json['username'] ?? '',
      code: json['code'] ?? '',
      lastname: json['lastname'] ?? '',
      firstname: json['firstname'] ?? '',
      businessName: json['businessName'] ?? '',
      avatar: json['avatar'] ?? '',
      countryCode: json['countryCode'] ?? '',
      statusUser: json['statusUser'] ?? '',
      statusReceiveOrder: json['statusReceiveOrder'] ?? '',
      imageFlag: json['imageFlag'] ?? '',
      imageCover: json['imageCover'] ?? '',
      skillId: json['skillId'] ?? 0,
      skillName: json['skillName'] ?? '',
      category: json['category'] ?? '',
      turnaroundTime: json['turnaroundTime'] ?? 0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      imageSkill: json['imageSkill'] ?? '',
      ratingPoint:
          (json['ratingPoint'] as num?)?.toDouble() ??
          (json['rating'] as num?)?.toDouble() ??
          0.0,
      totalReview: json['totalReview'] ?? json['numberReview'] ?? 0,
      userSkillId: json['userSkillId'] ?? 0,
      totalFavorite: json['totalFavorite'] ?? json['numberLike'] ?? 0,
      statusFavorite: json['statusFavorite'] ?? false,
      verified: json['verified'] ?? false,
      timezone: json['timezone'] ?? '',
      countryName: json['countryName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'code': code,
      'username': email,
      'lastname': lastname,
      'firstname': firstname,
      'businessName': businessName,
      'avatar': avatar,
      'countryCode': countryCode,
      'statusUser': statusUser,
      'statusReceiveOrder': statusReceiveOrder,
      'imageFlag': imageFlag,
      'imageCover': imageCover,
      'skillId': skillId,
      'skillName': skillName,
      'category': category,
      'turnaroundTime': turnaroundTime,
      'cost': cost,
      'imageSkill': imageSkill,
      'ratingPoint': ratingPoint,
      'totalReview': totalReview,
      'userSkillId': userSkillId,
      'totalFavorite': totalFavorite,
      'statusFavorite': statusFavorite,
      'verified': verified,
    };
  }

  //copy model
  DesignerModel copyWith({
    int? userId,
    String? code,
    String? lastname,
    String? firstname,
    String? email,
    String? businessName,
    String? avatar,
    String? countryCode,
    String? statusUser,
    String? statusReceiveOrder,
    String? imageFlag,
    String? imageCover,
    int? skillId,
    String? skillName,
    String? category,
    int? turnaroundTime,
    double? cost,
    String? imageSkill,
    double? ratingPoint,
    int? totalReview,
    int? userSkillId,
    int? totalFavorite,
    bool? statusFavorite,
    bool? verified,
    String? timezone,
    String? countryName,
  }) {
    return DesignerModel(
      userId: userId ?? this.userId,
      code: code ?? this.code,
      lastname: lastname ?? this.lastname,
      firstname: firstname ?? this.firstname,
      email: email ?? this.email,
      businessName: businessName ?? this.businessName,
      avatar: avatar ?? this.avatar,
      countryCode: countryCode ?? this.countryCode,
      statusUser: statusUser ?? this.statusUser,
      statusReceiveOrder: statusReceiveOrder ?? this.statusReceiveOrder,
      imageFlag: imageFlag ?? this.imageFlag,
      imageCover: imageCover ?? this.imageCover,
      skillId: skillId ?? this.skillId,
      skillName: skillName ?? this.skillName,
      category: category ?? this.category,
      turnaroundTime: turnaroundTime ?? this.turnaroundTime,
      cost: cost ?? this.cost,
      imageSkill: imageSkill ?? this.imageSkill,
      ratingPoint: ratingPoint ?? this.ratingPoint,
      totalReview: totalReview ?? this.totalReview,
      userSkillId: userSkillId ?? this.userSkillId,
      totalFavorite: totalFavorite ?? this.totalFavorite,
      statusFavorite: statusFavorite ?? this.statusFavorite,
      verified: verified ?? this.verified,
      timezone: timezone ?? this.timezone,
      countryName: countryName ?? this.countryName,
    );
  }

  String getStatusReceiveOrder() {
    switch (statusReceiveOrder) {
      case 'AUTO_ACCEPTING':
        return 'Auto Accepting';
      case 'ON_HOLD':
        return 'On Hold';
      case 'NOT_ACCEPTING':
        return 'Not Accepting';
      default:
        return statusReceiveOrder;
    }
  }

  Color getStatusColor() {
    switch (statusReceiveOrder) {
      case 'AUTO_ACCEPTING':
        return Colors.green;
      case 'ON_HOLD':
        return Colors.orange;
      case 'NOT_ACCEPTING':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Icon getStatusIcon() {
    switch (statusReceiveOrder) {
      case 'AUTO_ACCEPTING':
        return Icon(Icons.check, color: Colors.green, size: 16);
      case 'ON_HOLD':
        return Icon(Icons.warning, color: Colors.orange, size: 16);
      case 'NOT_ACCEPTING':
        return Icon(Icons.cancel_outlined, color: Colors.red, size: 16);
      default:
        return Icon(Icons.help, color: Colors.grey, size: 16);
    }
  }
}
