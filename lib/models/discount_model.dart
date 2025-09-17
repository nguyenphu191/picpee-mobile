class DiscountModel {
  final String id;
  final String promoCode;
  final String designerName;
  final String type; 
  final double amount;
  final bool status; 
  final DateTime createDate;

  DiscountModel({
    required this.id,
    required this.promoCode,
    required this.designerName,
    required this.type,
    required this.amount,
    required this.status,
    required this.createDate,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] as String,
      promoCode: json['promo_code'] as String,
      designerName: json['designer_name'] as String,
      type: json['type'] as String,
      amount: json['amount'] as double,
      status: json['status'] as bool,
      createDate: DateTime.parse(json['create_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promo_code': promoCode,
      'designer_name': designerName,
      'type': type,
      'amount': amount,
      'status': status,
      'create_date': createDate.toIso8601String(),
    };
  }
}