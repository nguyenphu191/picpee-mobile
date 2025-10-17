import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/discount_model.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;
import 'package:picpee_mobile/services/auth_service.dart';

class DiscountService {
  // Lấy list mã giảm giá của user
  Future<List<DiscountModel>> fetchUserDiscounts() async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    final response = await http.post(
      Uri.parse(Url.getAllDiscounts),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      final discounts = (data['list'] as List)
          .map((discountJson) => DiscountModel.fromJson(discountJson))
          .toList();
      final filterDisounts = discounts
          .where((discount) => discount.status == 'ACTIVE')
          .toList();
      return filterDisounts;
    } else {
      throw Exception('Failed to load user discounts');
    }
  }

  // Lấy thông tin mã giảm giá theo code
  Future<DiscountModel?> fetchDiscountByCode(String code, int vendorId) async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('User not logged in');
    }
    final response = await http.get(
      Uri.parse("${Url.getDiscount}?code=$code&vendorId=$vendorId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      return DiscountModel.fromJson(data);
    } else {
      throw Exception('Failed to load discount by code');
    }
  }
}
