import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/core/utils/url.dart' show Url;
import 'package:picpee_mobile/models/review_model.dart';
import 'package:picpee_mobile/services/auth_service.dart';

class ReviewService {
  final AuthService _authService = AuthService();

  Future<(List<ReviewModel>, int)> getReviewVendor({
    required int vendorId,
    int page = 1,
    int limit = 10,
  }) async {
    final String? token = await _authService.getToken();
    if (token == null) {
      print('No auth token found.');
      throw Exception('Authentication token is missing');
    }
    final url = Uri.parse(Url.getReviewOfVendor);

    print('Fetching reviews: vendorId=$vendorId, page=$page, limit=$limit');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'doerId': vendorId, 'page': page, 'limit': limit}),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      final review_list = data['list'] as List<dynamic>;
      final count = data['count'] as int;

      print('Received ${review_list.length} reviews, total count: $count');

      final reviews = review_list
          .map((reviewJson) => ReviewModel.fromJson(reviewJson))
          .toList();
      final totalPages = (count / limit).ceil();

      return (reviews, totalPages);
    } else {
      print('Failed to load review. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load review');
    }
  }
}
