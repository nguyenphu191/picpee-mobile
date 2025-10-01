import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://yourapi.com"; // đổi thành API backend của bạn

  /// Login với email + password
  Future<User?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = User.fromJson(data['data']);

      await _saveToken(token);
      await _saveUser(user);

      return user;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  /// Login với Google SSO
  Future<User?> loginSSO(String googleToken) async {
    final url = Uri.parse("$baseUrl/login-sso");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"googleToken": googleToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = User.fromJson(data['data']);

      await _saveToken(token);
      await _saveUser(user);

      return user;
    } else {
      throw Exception("Login SSO failed: ${response.body}");
    }
  }

  /// Register
  Future<User?> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String businessName,
    required String phone,
    required String country,
    required String timezone,
  }) async {
    final url = Uri.parse("$baseUrl/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
        "businessName": businessName,
        "phone": phone,
        "country": country,
        "timezone": timezone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = User.fromJson(data['data']);

      await _saveToken(token);
      await _saveUser(user);

      return user;
    } else {
      throw Exception("Register failed: ${response.body}");
    }
  }

  /// Lưu token vào local storage
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  /// Lấy token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// Xoá token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  /// Lưu user vào storage
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", jsonEncode(user.toJson()));
  }

  /// Lấy user từ storage
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("user");
    if (data != null) {
      return User.fromJson(jsonDecode(data));
    }
    return null;
  }

  /// Đăng xuất
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
