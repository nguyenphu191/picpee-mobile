import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/comment_model.dart';
import 'package:picpee_mobile/models/order_activity_model.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  bool _isloading = false;
  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;
  List<OrderActivityModel> _activities = [];
  List<CommentModel> _comments = [];
  List<OrderAddOn> _checklist = [];

  bool get loading => _isloading;
  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;
  List<OrderActivityModel> get activities => _activities;
  List<CommentModel> get comments => _comments;
  List<OrderAddOn> get checklist => _checklist;

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
      final orders = await _orderService.fetchOrders(projectId: projectId);
      _orders = orders
          .where(
            (order) =>
                (order.status != 'PENDING_ORDER' &&
                order.status != 'CANCELLED'),
          )
          .toList();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> fetchOrdersByStaus(String status) async {
    setLoading(true);
    _orders = [];
    try {
      final orders = await _orderService.fetchOrders();
      _orders = orders.where((order) => order.status == status).toList();
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
    _currentOrder = null;
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
      setCurrentOrder(newOrder);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> purchaseOrder({required int orderId, String? code}) async {
    setLoading(true);
    try {
      final order = await _orderService.payOrder(orderId, code);
      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = order;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Xóa order
  Future<bool> deleteOrder(int orderId) async {
    setLoading(true);
    try {
      final success = await _orderService.deleteOrder(orderId);
      if (success) {
        _orders.removeWhere((order) => order.id == orderId);
        notifyListeners();
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

  // Fetch order comments
  Future<bool> fetchOrderComments(int orderId) async {
    setLoading(true);
    try {
      _comments = await _orderService.fetchOrderComments(orderId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Add a new comment
  Future<bool> addComment(Map<String, dynamic> commentData) async {
    setLoading(true);
    try {
      final success = await _orderService.addComment(commentData);
      if (success) {
        if (commentData.containsKey('orderId')) {
          int orderId = commentData['orderId'];
          await fetchOrderComments(orderId);
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

  //Edit a comment
  Future<bool> editComment(
    int commentId,
    Map<String, dynamic> commentData,
  ) async {
    setLoading(true);
    try {
      final success = await _orderService.updateComment(commentId, commentData);
      if (success) {
        if (commentData.containsKey('orderId')) {
          int orderId = commentData['orderId'];
          await fetchOrderComments(orderId);
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

  // Delete a comment
  Future<bool> deleteComment(int commentId) async {
    setLoading(true);
    try {
      final success = await _orderService.deleteComment(commentId);
      if (success) {
        _comments.removeWhere((comment) => comment.id == commentId);
        notifyListeners();
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

  //get checklist
  Future<bool> fetchChecklist(int orderId) async {
    setLoading(true);
    try {
      _checklist = await _orderService.fetchChecklist(orderId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }
}
