class SkillOfVendorModel {
  final int id;
  final int userId;
  final String skillCategory;
  final int skillId;
  final String skillName;
  final String skillDescription;
  final int limitNumberImage;
  final int maxNumberImage;
  final String skillType;
  final String skillTypeUpload;
  final double cost;
  final double cost30s;
  final double costHorizontalVertical;
  final int turnaroundTime;
  final int performance;
  final int numberImage;
  final String status;
  final List<SkillImage> images;
  final List<AddOnModel> userSkillAddOnsRes;
  final String urlImage;

  SkillOfVendorModel({
    required this.id,
    required this.userId,
    required this.skillCategory,
    required this.skillId,
    required this.skillName,
    required this.skillDescription,
    required this.limitNumberImage,
    required this.maxNumberImage,
    required this.skillType,
    required this.skillTypeUpload,
    required this.cost,
    required this.cost30s,
    required this.costHorizontalVertical,
    required this.turnaroundTime,
    required this.performance,
    required this.numberImage,
    required this.status,
    required this.images,
    required this.userSkillAddOnsRes,
    required this.urlImage,
  });

  factory SkillOfVendorModel.fromJson(Map<String, dynamic> json) {
    return SkillOfVendorModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      skillCategory: json['skillCategory'] ?? '',
      skillId: json['skillId'] ?? 0,
      skillName: json['skillName'] ?? '',
      skillDescription: json['skillDescription'] ?? '',
      limitNumberImage: json['limitNumberImage'] ?? 0,
      maxNumberImage: json['maxNumberImage'] ?? 0,
      skillType: json['skillType'] ?? '',
      skillTypeUpload: json['skillTypeUpload'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      cost30s: (json['cost30s'] as num?)?.toDouble() ?? 0.0,
      costHorizontalVertical:
          (json['costHorizontalVertical'] as num?)?.toDouble() ?? 0.0,
      turnaroundTime: json['turnaroundTime'] ?? 0,
      performance: json['performance'] ?? 0,
      numberImage: json['numberImage'] ?? 0,
      status: json['status'] ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => SkillImage.fromJson(e))
              .toList() ??
          [],
      userSkillAddOnsRes:
          (json['userSkillAddOnsRes'] as List<dynamic>?)
              ?.map((e) => AddOnModel.fromJson(e))
              .toList() ??
          [],
      urlImage: json['urlImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'skillCategory': skillCategory,
      'skillId': skillId,
      'skillName': skillName,
      'skillDescription': skillDescription,
      'limitNumberImage': limitNumberImage,
      'maxNumberImage': maxNumberImage,
      'skillType': skillType,
      'skillTypeUpload': skillTypeUpload,
      'cost': cost,
      'cost30s': cost30s,
      'costHorizontalVertical': costHorizontalVertical,
      'turnaroundTime': turnaroundTime,
      'performance': performance,
      'numberImage': numberImage,
      'status': status,
      'images': images.map((e) => e.toJson()).toList(),
      'userSkillAddOnsRes': userSkillAddOnsRes,
      'urlImage': urlImage,
    };
  }
}

class SkillImage {
  final String typeUpload;
  final String? imageBefore;
  final String? imageAfter;
  final String? imageLink;

  SkillImage({
    required this.typeUpload,
    this.imageBefore,
    this.imageAfter,
    this.imageLink,
  });

  factory SkillImage.fromJson(Map<String, dynamic> json) {
    return SkillImage(
      typeUpload: json['typeUpload'] ?? '',
      imageBefore: json['imageBefore'],
      imageAfter: json['imageAfter'],
      imageLink: json['imageLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeUpload': typeUpload,
      'imageBefore': imageBefore,
      'imageAfter': imageAfter,
      'imageLink': imageLink,
    };
  }
}

class AddOnModel {
  int id;
  int userAddonsId;
  double cost;
  bool isActive;
  String name;
  String unit;
  String description;

  AddOnModel({
    required this.id,
    required this.userAddonsId,
    required this.cost,
    required this.isActive,
    required this.name,
    required this.unit,
    required this.description,
  });

  factory AddOnModel.fromJson(Map<String, dynamic> json) {
    return AddOnModel(
      id: json['id'] ?? 0,
      userAddonsId: json['userAddonsId'] ?? 0,
      cost: (json['cost'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? false,
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillAddOnsId': id,
      'cost': cost,
      'isActive': isActive,
      'name': name,
      'unit': unit,
      'description': description,
    };
  }
}
