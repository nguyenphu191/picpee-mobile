import 'dart:ui';
import 'package:flutter/material.dart';

class SkillModel {
  final Skill? skill;
  final List<TopDesigner> topDesigners;

  SkillModel({this.skill, required this.topDesigners});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skill: json['skill'] != null ? Skill.fromJson(json['skill']) : null,
      topDesigners:
          (json['topDesigners'] as List<dynamic>?)
              ?.map((e) => TopDesigner.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skill': skill?.toJson(),
      'topDesigners': topDesigners.map((e) => e.toJson()).toList(),
    };
  }
}

class Skill {
  final int id;
  final String category;
  final String name;
  final double costDefault;
  final int turnaroundTimeDefault;
  final int performanceDefault;
  final int limitNumberImage;
  final int maxNumberImage;
  final String description;
  final String type;
  final String typeUpload;
  final String status;
  final int orderNo;
  final String urlImage;
  final String alias;
  final bool isShowHome;
  final String backgroudColor;
  final int classCard;
  final List<dynamic> skillAddOnsRes;

  Skill({
    required this.id,
    required this.category,
    required this.name,
    required this.costDefault,
    required this.turnaroundTimeDefault,
    required this.performanceDefault,
    required this.limitNumberImage,
    required this.maxNumberImage,
    required this.description,
    required this.type,
    required this.typeUpload,
    required this.status,
    required this.orderNo,
    required this.urlImage,
    required this.alias,
    required this.isShowHome,
    required this.backgroudColor,
    required this.classCard,
    required this.skillAddOnsRes,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      costDefault: (json['costDefault'] as num?)?.toDouble() ?? 0.0,
      turnaroundTimeDefault: json['turnaroundTimeDefault'] ?? 0,
      performanceDefault: json['performanceDefault'] ?? 0,
      limitNumberImage: json['limitNumberImage'] ?? 0,
      maxNumberImage: json['maxNumberImage'] ?? 0,
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      typeUpload: json['typeUpload'] ?? '',
      status: json['status'] ?? '',
      orderNo: json['orderNo'] ?? 0,
      urlImage: json['urlImage'] ?? '',
      alias: json['alias'] ?? '',
      isShowHome: json['isShowHome'] ?? false,
      backgroudColor: json['backgroudColor'] ?? '',
      classCard: json['classCard'] ?? 0,
      skillAddOnsRes: json['skillAddOnsRes'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'costDefault': costDefault,
      'turnaroundTimeDefault': turnaroundTimeDefault,
      'performanceDefault': performanceDefault,
      'limitNumberImage': limitNumberImage,
      'maxNumberImage': maxNumberImage,
      'description': description,
      'type': type,
      'typeUpload': typeUpload,
      'status': status,
      'orderNo': orderNo,
      'urlImage': urlImage,
      'alias': alias,
      'isShowHome': isShowHome,
      'backgroudColor': backgroudColor,
      'classCard': classCard,
      'skillAddOnsRes': skillAddOnsRes,
    };
  }
}

class TopDesigner {
  final int userId;
  final String code;
  final String lastname;
  final String firstname;
  final String businessName;
  final String avatar;
  final String countryCode;
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

  TopDesigner({
    required this.userId,
    required this.code,
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
  });

  factory TopDesigner.fromJson(Map<String, dynamic> json) {
    return TopDesigner(
      userId: json['userId'] ?? 0,
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
      ratingPoint: (json['ratingPoint'] as num?)?.toDouble() ?? 0.0,
      totalReview: json['totalReview'] ?? 0,
      userSkillId: json['userSkillId'] ?? 0,
      totalFavorite: json['totalFavorite'] ?? 0,
      statusFavorite: json['statusFavorite'] ?? false,
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'code': code,
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
