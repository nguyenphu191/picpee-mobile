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
      throw Exception('Authentication token is missing');
    }
    final url = Uri.parse(Url.getReviewOfVendor);

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

      final reviews = review_list
          .map((reviewJson) => ReviewModel.fromJson(reviewJson))
          .toList();
      final totalPages = (count / limit).ceil();

      return (reviews, totalPages);
    } else {
      throw Exception('Failed to load review');
    }
  }

  Future<List<Reviewer>> getVendorOfProject(int projectId) async {
    print('Fetching vendors SERVICE: $projectId');
    final String? token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token is missing');
    }
    final url = Uri.parse(Url.getVendorsOfProject);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'projectId': projectId}),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data']['list'] as List<dynamic>;

      final vendors = data
          .map((vendorJson) => Reviewer.fromJson(vendorJson))
          .toList();

      return vendors;
    } else {
      throw Exception('Failed to load vendors of project');
    }
  }

  Future<ReviewModel> getOneReviewVendor(int vendorId) async {
    final String? token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token is missing');
    }
    final url = Uri.parse("${Url.getOneReview}/$vendorId");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];

      final review = ReviewModel.fromJson(data);

      return review;
    } else {
      throw Exception('Failed to load review');
    }
  }

  Future<String> createReviewVendor({
    required int vendorId,
    required int rating,
    required String comment,
  }) async {
    final String? token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token is missing');
    }
    final url = Uri.parse(Url.submitReview);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'doerId': vendorId,
        'rating': rating,
        'comment': comment,
      }),
    );

    final res = jsonDecode(response.body);
    final message = res['message'];
    return message;
  }

  Future<String> updateReviewVendor({
    required int reviewId,
    required int vendorId,
    required int rating,
    required String comment,
  }) async {
    final String? token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token is missing');
    }
    final url = Uri.parse("${Url.submitReview}/$reviewId");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'doerId': vendorId,
        'rating': rating,
        'comment': comment,
      }),
    );

    final res = jsonDecode(response.body);
    final message = res['message'];
    return message;
  }
}
