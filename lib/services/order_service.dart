import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/comment_model.dart';
import 'package:picpee_mobile/models/order_activity_model.dart';
import 'package:picpee_mobile/models/order_model.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;
import 'package:picpee_mobile/services/auth_service.dart';

class OrderService {
  // Lấy list orders của project
  Future<List<OrderModel>> fetchOrders(int projectId) async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse(Url.getOrdersOfProject),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'projectId': projectId}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      final orders = (data['list'] as List)
          .map((orderJson) => OrderModel.fromJson(orderJson))
          .toList();
      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // Lấy chi tiết order
  Future<OrderModel?> fetchOrderDetails(int orderId) async {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse("${Url.getDetailOrder}/$orderId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      return OrderModel.fromJson(data);
    } else if (response.statusCode == 404) {
      return null; // Order not found
    } else {
      throw Exception('Failed to load order details');
    }
  }

  // Tạo order mới
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse(Url.createOrder),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      return OrderModel.fromJson(data);
    } else {
      throw Exception('Failed to create order');
    }
  }

  // Hoàn thành order
  Future<bool> completeOrder(int orderId) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse("${Url.completedOrder}/$orderId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //Dispute order
  Future<bool> disputeOrder(int orderId, String reason) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse("${Url.disputeOrder}/$orderId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'note': reason}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Revision order
  Future<bool> revisionOrder(int orderId, String note) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse("${Url.revisionOrder}/$orderId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'note': note}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //Lấy order activity
  Future<List<OrderActivityModel>> fetchOrderActivities(int orderId) async {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse("${Url.getActivity}/$orderId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      List<OrderActivityModel> activities = (data as List)
          .map((activityJson) => OrderActivityModel.fromJson(activityJson))
          .toList();
      return activities;
    } else {
      throw Exception('Failed to load order activities');
    }
  }

  //Lấy comments
  Future<List<CommentModel>> fetchOrderComments(int orderId) async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse(Url.getComment),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'orderId': orderId}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      List<CommentModel> comments = (data as List)
          .map((commentJson) => CommentModel.fromJson(commentJson))
          .toList();
      return comments;
    } else {
      throw Exception('Failed to load order comments');
    }
  }

  // Thêm comment
  Future<bool> addComment(Map<String, dynamic> commentData) async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse(Url.addComment),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({...commentData}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Xoá comment
  Future<bool> deleteComment(int commentId) async {
    final token = await AuthService().getToken();
    final response = await http.delete(
      Uri.parse("${Url.addComment}/$commentId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Cập nhật comment
  Future<bool> updateComment(int id, Map<String, dynamic> commentData) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse("${Url.addComment}/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({...commentData}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
