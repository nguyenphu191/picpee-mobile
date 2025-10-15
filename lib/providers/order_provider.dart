import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/order_activity_model.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  bool _isloading = false;
  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;
  List<OrderActivityModel> _activities = [];

  bool get loading => _isloading;
  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;
  List<OrderActivityModel> get activities => _activities;

  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  void setCurrentOrder(OrderModel? order) {
    _currentOrder = order;
    notifyListeners();
  }

  Future<bool> fetchOrders(int projectId) async {
    setLoading(true);
    _orders = [];
    try {
      _orders = await _orderService.fetchOrders(projectId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> fetchOrderDetails(int orderId) async {
    setLoading(true);
    try {
      final order = await _orderService.fetchOrderDetails(orderId);
      if (order != null) {
        setCurrentOrder(order);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    setLoading(true);
    try {
      final newOrder = await _orderService.createOrder(orderData);
      _orders.add(newOrder);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> completeOrder(int orderId) async {
    setLoading(true);
    try {
      final success = await _orderService.completeOrder(orderId);
      if (success) {
        final index = _orders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          _orders[index] = OrderModel(
            id: _orders[index].id,
            projectName: _orders[index].projectName,
            code: _orders[index].code,
            status: "COMPLETED",
            cost: _orders[index].cost,
            subTotal: _orders[index].subTotal,
            taxAmount: _orders[index].taxAmount,
            startedTime: _orders[index].startedTime,
            deliveredTime: _orders[index].deliveredTime,
            completedTime: DateTime.now().toIso8601String(),
            createdTime: _orders[index].createdTime,
            customer: _orders[index].customer,
            vendor: _orders[index].vendor,
            skill: _orders[index].skill,
            projectId: _orders[index].projectId,
            customerId: _orders[index].customerId,
            vendorId: _orders[index].vendorId,
            type: _orders[index].type,
            quantity: _orders[index].quantity,
            dueTime: _orders[index].dueTime,
            guideline: _orders[index].guideline,
            sourceFilesLink: _orders[index].sourceFilesLink,
            deliverableFilesLink: _orders[index].deliverableFilesLink,
            skillId: _orders[index].skillId,
            orderTransaction: _orders[index].orderTransaction,
            orientationType: _orders[index].orientationType,
            aspectRatio: _orders[index].aspectRatio,
            resolution: _orders[index].resolution,
            framerate: _orders[index].framerate,
            fileType: _orders[index].fileType,
            countComments: _orders[index].countComments,
          );
          notifyListeners();
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Dispute order
  Future<bool> disputeOrder(int orderId, String note) async {
    setLoading(true);
    try {
      final success = await _orderService.disputeOrder(orderId, note);
      if (success) {
        final index = _orders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          _orders[index] = OrderModel(
            id: _orders[index].id,
            projectName: _orders[index].projectName,
            code: _orders[index].code,
            status: "DISPUTED",
            cost: _orders[index].cost,
            subTotal: _orders[index].subTotal,
            taxAmount: _orders[index].taxAmount,
            startedTime: _orders[index].startedTime,
            deliveredTime: _orders[index].deliveredTime,
            completedTime: _orders[index].completedTime,
            createdTime: _orders[index].createdTime,
            customer: _orders[index].customer,
            vendor: _orders[index].vendor,
            skill: _orders[index].skill,
            projectId: _orders[index].projectId,
            customerId: _orders[index].customerId,
            vendorId: _orders[index].vendorId,
            type: _orders[index].type,
            quantity: _orders[index].quantity,
            dueTime: _orders[index].dueTime,
            guideline: _orders[index].guideline,
            sourceFilesLink: _orders[index].sourceFilesLink,
            deliverableFilesLink: _orders[index].deliverableFilesLink,
            skillId: _orders[index].skillId,
            orderTransaction: _orders[index].orderTransaction,
            orientationType: _orders[index].orientationType,
            aspectRatio: _orders[index].aspectRatio,
            resolution: _orders[index].resolution,
            framerate: _orders[index].framerate,
            fileType: _orders[index].fileType,
            countComments: _orders[index].countComments,
          );
          notifyListeners();
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Revision order
  Future<bool> revisionOrder(int orderId, String note) async {
    setLoading(true);
    try {
      final success = await _orderService.revisionOrder(orderId, note);
      if (success) {
        final index = _orders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          _orders[index] = OrderModel(
            id: _orders[index].id,
            projectName: _orders[index].projectName,
            code: _orders[index].code,
            status: "AWAITING_REVISION",
            cost: _orders[index].cost,
            subTotal: _orders[index].subTotal,
            taxAmount: _orders[index].taxAmount,
            startedTime: _orders[index].startedTime,
            deliveredTime: _orders[index].deliveredTime,
            completedTime: _orders[index].completedTime,
            createdTime: _orders[index].createdTime,
            customer: _orders[index].customer,
            vendor: _orders[index].vendor,
            skill: _orders[index].skill,
            projectId: _orders[index].projectId,
            customerId: _orders[index].customerId,
            vendorId: _orders[index].vendorId,
            type: _orders[index].type,
            quantity: _orders[index].quantity,
            dueTime: _orders[index].dueTime,
            guideline: _orders[index].guideline,
            sourceFilesLink: _orders[index].sourceFilesLink,
            deliverableFilesLink: _orders[index].deliverableFilesLink,
            skillId: _orders[index].skillId,
            orderTransaction: _orders[index].orderTransaction,
            orientationType: _orders[index].orientationType,
            aspectRatio: _orders[index].aspectRatio,
            resolution: _orders[index].resolution,
            framerate: _orders[index].framerate,
            fileType: _orders[index].fileType,
            countComments: _orders[index].countComments,
          );
          notifyListeners();
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> fetchOrderActivities(int orderId) async {
    setLoading(true);
    _activities = [];
    try {
      _activities = await _orderService.fetchOrderActivities(orderId);
      print("Fetched activities: ${_activities.length}");
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }
}
