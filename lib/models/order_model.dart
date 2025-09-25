import 'package:flutter/material.dart';
import 'package:picpee_mobile/core/images/app_image.dart';

enum OrderStatus {
  inCart('In Cart'),
  inProgress('In progress'),
  delivered('Delivered'),
  pendingVendorConfirm('Pending Vendor Confirm'),
  completed('Completed'),
  awaitingRevision('Awaiting revision'),
  dispute('Dispute'),
  resolve('Resolve');

  const OrderStatus(this.displayName);
  final String displayName;
}

class Order {
  final String id;
  final String serviceName;
  final double amount;
  final double total;
  final String designerName;
  final String designerAvatar;
  final DateTime submitted;
  final DateTime dueDate;
  final OrderStatus status;
  final List<String> checklist;
  bool isChecked;

  Order({
    required this.id,
    required this.serviceName,
    required this.amount,
    required this.total,
    required this.designerName,
    required this.designerAvatar,
    required this.submitted,
    required this.dueDate,
    required this.status,
    required this.checklist,
    this.isChecked = false,
  });

  // Factory constructor to create Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      designerName: json['designerName'] ?? '',
      designerAvatar: json['designerAvatar'] ?? '',
      submitted: DateTime.parse(
        json['submitted'] ?? DateTime.now().toIso8601String(),
      ),
      dueDate: DateTime.parse(
        json['dueDate'] ?? DateTime.now().toIso8601String(),
      ),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.inProgress,
      ),
      checklist: List<String>.from(json['checklist'] ?? []),
      isChecked: json['isChecked'] ?? false,
    );
  }

  // Convert Order to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'amount': amount,
      'total': total,
      'designerName': designerName,
      'designerAvatar': designerAvatar,
      'submitted': submitted.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'checklist': checklist,
      'isChecked': isChecked,
    };
  }

  // Copy with method for updating fields
  Order copyWith({
    String? id,
    String? serviceName,
    double? amount,
    double? total,
    String? designerName,
    String? designerAvatar,
    DateTime? submitted,
    DateTime? dueDate,
    OrderStatus? status,
    List<String>? checklist,
    bool? isChecked,
  }) {
    return Order(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      amount: amount ?? this.amount,
      total: total ?? this.total,
      designerName: designerName ?? this.designerName,
      designerAvatar: designerAvatar ?? this.designerAvatar,
      submitted: submitted ?? this.submitted,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      checklist: checklist ?? this.checklist,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  Color getStatusColor() {
    switch (status) {
      case OrderStatus.inProgress:
        return Colors.grey;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.pendingVendorConfirm:
        return Colors.purple;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.awaitingRevision:
        return Colors.orange;
      case OrderStatus.dispute:
        return Colors.redAccent;
      case OrderStatus.resolve:
        return Colors.teal;
      case OrderStatus.inCart:
        return Colors.blue;
    }
  }

  IconData getStatusIcon() {
    switch (status) {
      case OrderStatus.inProgress:
        return Icons.calendar_month;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.pendingVendorConfirm:
        return Icons.hourglass_top;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.awaitingRevision:
        return Icons.edit;
      case OrderStatus.dispute:
        return Icons.error;
      case OrderStatus.resolve:
        return Icons.check_circle_outline;
      case OrderStatus.inCart:
        return Icons.shopping_cart;
    }
  }

  String getServiceImg() {
    switch (serviceName) {
      case 'Single Exposure':
        return AppImages.SingleExportIcon;
      case 'Blended Brackets (HDR)':
        return AppImages.HDRIcon;
      case 'Flambient':
        return AppImages.FlambientIcon;
      case '360° Image Enhancement':
        return AppImages.Image360EnhanceIcon;
      case 'Virtual Staging':
        return AppImages.VirtualStaggingIcon;
      case 'Remodel':
        return AppImages.RemodelIcon;
      case '360° Image':
        return AppImages.Image360Icon;
      case 'Day to Dusk':
        return AppImages.DayToDuckIcon;
      case 'Day to Twilight':
        return AppImages.DayToTwilightIcon;
      case '1-4 Items':
        return AppImages.CleanIcon;
      case 'Room Cleaning':
        return AppImages.CleanIcon;
      case 'Changing Seasons':
        return AppImages.ChangeSessionIcon;
      case 'Water In Pool':
        return AppImages.WaterInPoolIcon;
      case 'Lawn Replacement':
        return AppImages.LawnReplacementIcon;
      case 'Rain to Shine':
        return AppImages.RainToShineIcon;
      case 'Custom 2D':
        return AppImages.Custom2dIcon;
      case 'Custom 3D':
        return AppImages.Custom3dIcon;
      case 'Property Videos':
        return AppImages.PropertyIcon;
      case 'Walkthrough Video':
        return AppImages.WalkthroughIcon;
      case 'Reels':
        return AppImages.ReelsIcon;
      case 'Slideshows':
        return AppImages.SlideShowIcon;
      case 'Individual':
        return AppImages.IndividualIcon;
      case 'Team':
        return AppImages.TeamIcon;
      case 'Add Person':
        return AppImages.AddPersonIcon;
      case 'Remove Person':
        return AppImages.RemovePersonIcon;
      case 'Background Replacement':
        return AppImages.BackgroundReplaceIcon;
      case 'Cut Outs':
        return AppImages.CutsOutIcon;
      case 'Change Color':
        return AppImages.ChangeColorIcon;
      default:
        return AppImages.FolderIcon;
    }
  }
}
