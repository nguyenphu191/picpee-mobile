import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/user_model.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;
import 'package:picpee_mobile/services/auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();

  Future<User?> updateProfile(int userId, Map<String, dynamic> data) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception("No token found");
    }
    final url = Uri.parse("${Url.updateAcc}/$userId");
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['data'];
      return User.fromJson(data);
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
