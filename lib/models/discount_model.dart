import 'package:intl/intl.dart';
import 'package:picpee_mobile/models/designer_model.dart';

class DiscountModel {
  int id;
  String code;
  String vendorId;
  String customerId;
  String status;
  String discountType;
  String startTime;
  String endTime;
  double discountValue;
  String createdTime;
  String modifiedTime;
  DesignerModel? vendor;

  DiscountModel({
    required this.id,
    required this.code,
    required this.vendorId,
    required this.customerId,
    required this.status,
    required this.discountType,
    required this.startTime,
    required this.endTime,
    required this.discountValue,
    required this.createdTime,
    required this.modifiedTime,
    this.vendor,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      vendorId: json['vendorId'] ?? '',
      customerId: json['customerId'] ?? '',
      status: json['status'] ?? '',
      discountType: json['discountType'] ?? '',
      startTime: _timestampToDate(json['startTime'] ?? 0),
      endTime: _timestampToDate(json['endTime'] ?? 0),
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      createdTime: _timestampToDate(json['createdTime'] ?? 0),
      modifiedTime: _timestampToDate(json['modifiedTime'] ?? 0),
      vendor: json['vendor'] != null
          ? DesignerModel.fromJson(json['vendor'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'vendorId': vendorId,
      'customerId': customerId,
      'status': status,
      'discountType': discountType,
      'startTime': startTime,
      'endTime': endTime,
      'discountValue': discountValue,
      'createdTime': createdTime,
      'modifiedTime': modifiedTime,
      'vendor': vendor?.toJson(),
    };
  }

  /// Chuyển timestamp UTC -> giờ local của thiết bị và format
  static String _timestampToDate(dynamic value) {
    if (value == null || value == 0) {
      return "";
    }
    // Convert từ UTC sang giờ local
    final utcDate = DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    final localDate = utcDate.toLocal();

    return DateFormat('dd/MM/yyyy hh:mm a').format(localDate);
  }
}
