import 'dart:convert';
import 'package:picpee_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const _tokenKey = "auth_token";
  static const _userKey = "auth_user";

  final String baseUrl = "https://api.example.com"; // đổi thành API thật

  // Login API
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data["token"];
      final user = User.fromJson(data["user"]);

      // Lưu xuống storage
      await _saveAuthData(token, user);

      return {"token": token, "user": user};
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  // Logout (clear storage)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Lấy dữ liệu auth từ local storage
  Future<Map<String, dynamic>?> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);

    if (token != null && userJson != null) {
      final user = User.fromJson(json.decode(userJson));
      return {"token": token, "user": user};
    }
    return null;
  }

  // Private: lưu dữ liệu
  Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }
}
