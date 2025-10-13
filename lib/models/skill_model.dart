import 'package:picpee_mobile/models/designer_model.dart';

class SkillModel {
  final Skill? skill;
  final List<DesignerModel> topDesigners;

  SkillModel({this.skill, required this.topDesigners});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      skill: json['skill'] != null ? Skill.fromJson(json['skill']) : null,
      topDesigners:
          (json['topDesigners'] as List<dynamic>?)
              ?.map((e) => DesignerModel.fromJson(e))
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
