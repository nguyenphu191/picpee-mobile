import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:picpee_mobile/models/skill_model.dart';
import 'package:picpee_mobile/models/user_model.dart';

class OrderModel {
  int id;
  String code;
  int projectId;
  int customerId;
  int vendorId;
  String status;
  String type;
  int quantity;
  String dueTime;
  String guideline;
  String sourceFilesLink;
  int countComments = 0;
  String deliverableFilesLink;
  int skillId;
  double cost;
  double subTotal;
  double taxAmount;
  String startedTime;
  String deliveredTime;
  String completedTime;
  String createdTime;
  User? customer;
  User? vendor;
  Skill? skill;
  String projectName;
  OrderTransactionModel? orderTransaction;
  String orientationType;
  String aspectRatio;
  String resolution;
  String framerate;
  String fileType;

  OrderModel({
    required this.id,
    required this.code,
    required this.projectId,
    required this.customerId,
    required this.vendorId,
    required this.status,
    required this.type,
    required this.quantity,
    required this.dueTime,
    required this.guideline,
    required this.sourceFilesLink,
    required this.deliverableFilesLink,
    required this.skillId,
    required this.cost,
    required this.subTotal,
    required this.taxAmount,
    required this.startedTime,
    required this.deliveredTime,
    required this.completedTime,
    required this.createdTime,
    this.customer,
    this.vendor,
    this.skill,
    required this.projectName,
    this.orderTransaction,
    required this.orientationType,
    required this.aspectRatio,
    required this.resolution,
    required this.framerate,
    required this.fileType,
    required this.countComments,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      code: json['code'] ?? '',
      projectId: json['projectId'] ?? 0,
      customerId: json['customerId'] ?? 0,
      vendorId: json['vendorId'] ?? 0,
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      quantity: json['quantity'] ?? 0,
      dueTime: _timestampToDate(json['dueTime'] ?? 0),
      guideline: json['guideline'] ?? '',
      sourceFilesLink: json['sourceFilesLink'] ?? '',
      deliverableFilesLink: json['deliverableFilesLink'] ?? '',
      skillId: json['skillId'] ?? 0,
      cost: (json['cost'] ?? 0).toDouble(),
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      startedTime: _timestampToDate(json['startedTime']),
      deliveredTime: _timestampToDate(json['deliveredTime']),
      completedTime: _timestampToDate(json['completedTime']),
      createdTime: _timestampToDate(json['createdTime']),
      customer: json['customer'] != null
          ? User.fromJson(json['customer'])
          : null,
      vendor: json['vendor'] != null ? User.fromJson(json['vendor']) : null,
      skill: json['skill'] != null ? Skill.fromJson(json['skill']) : null,
      projectName: json['projectName'] ?? '',
      orderTransaction: json['orderTransactionRes'] != null
          ? OrderTransactionModel.fromJson(json['orderTransactionRes'])
          : null,
      orientationType: json['orientationType'] ?? '',
      aspectRatio: json['aspectRatio'] ?? '',
      resolution: json['resolution'] ?? '',
      framerate: json['framerate'] ?? '',
      fileType: json['fileType'] ?? '',
      countComments: json['countComment'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'projectId': projectId,
      'customerId': customerId,
      'vendorId': vendorId,
      'status': status,
      'type': type,
      'quantity': quantity,
      'dueTime': dueTime,
      'guideline': guideline,
      'sourceFilesLink': sourceFilesLink,
      'deliverableFilesLink': deliverableFilesLink,
      'skillId': skillId,
      'cost': cost,
      'subTotal': subTotal,
      'taxAmount': taxAmount,
      'startedTime': startedTime,
      'deliveredTime': deliveredTime,
      'completedTime': completedTime,
      'createdTime': createdTime,
      'customer': customer?.toJson(),
      'vendor': vendor?.toJson(),
      'skill': skill?.toJson(),
      'projectName': projectName,
      'orderTransactionRes': orderTransaction?.toJson(),
      'orientationType': orientationType,
      'aspectRatio': aspectRatio,
      'resolution': resolution,
      'framerate': framerate,
      'fileType': fileType,
    };
  }

  Color getStatusColor() {
    switch (status) {
      case "IN_PROGRESS":
        return Colors.grey;
      case "DELIVERED":
        return Colors.green;
      case "PENDING_VENDOR_CONFIRM":
        return Colors.purple;
      case 'PENDING_ORDER':
        return Colors.grey;
      case "COMPLETED":
        return Colors.green;
      case "AWAITING_REVISION":
        return Colors.orange;
      case "DISPUTED":
        return Colors.redAccent;
      case "RESOLVED":
        return Colors.red;
      case 'CANCELLED':
        return Colors.red;
      case "IN_CART":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (status) {
      case 'IN_PROGRESS':
        return Icons.calendar_month;
      case 'DELIVERED':
        return Icons.check_circle;
      case 'PENDING_VENDOR_CONFIRM':
        return Icons.hourglass_top;
      case 'PENDING_ORDER':
        return Icons.hourglass_top;
      case 'COMPLETED':
        return Icons.check_circle;
      case 'AWAITING_REVISION':
        return Icons.edit;
      case 'DISPUTED':
        return Icons.error;
      case 'RESOLVED':
        return Icons.check_circle_outline;
      case 'CANCELLED':
        return Icons.check_circle_outline;
      case 'IN_CART':
        return Icons.shopping_cart;
      default:
        return Icons.help_outline;
    }
  }

  String getStatusText() {
    switch (status) {
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'DELIVERED':
        return 'Delivered';
      case 'PENDING_VENDOR_CONFIRM':
        return 'Pending Vendor Confirm';
      case 'PENDING_ORDER':
        return 'In Progress';
      case 'COMPLETED':
        return 'Completed';
      case 'AWAITING_REVISION':
        return 'Awaiting Revision';
      case 'DISPUTED':
        return 'Disputed';
      case 'RESOLVED':
        return 'Resolved';
      case 'IN_CART':
        return 'In Cart';
      case 'CANCELLED':
        return 'Resolved';
      default:
        return status;
    }
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

class OrderTransactionModel {
  int orderId;
  int payerId;
  double priceSkill;
  double priceAddons;
  double priceTax;
  double priceTotal;
  String status;

  OrderTransactionModel({
    required this.orderId,
    required this.payerId,
    required this.priceSkill,
    required this.priceAddons,
    required this.priceTax,
    required this.priceTotal,
    required this.status,
  });

  factory OrderTransactionModel.fromJson(Map<String, dynamic> json) {
    return OrderTransactionModel(
      orderId: json['orderId'],
      payerId: json['payerId'],
      priceSkill: (json['priceSkill'] ?? 0).toDouble(),
      priceAddons: (json['priceAddons'] ?? 0).toDouble(),
      priceTax: (json['priceTax'] ?? 0).toDouble(),
      priceTotal: (json['priceTotal'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'payerId': payerId,
      'priceSkill': priceSkill,
      'priceAddons': priceAddons,
      'priceTax': priceTax,
      'priceTotal': priceTotal,
      'status': status,
    };
  }
}
