import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;
import 'package:picpee_mobile/core/utils/encryption.dart' show EncryptionUtil;

class AuthService {
  /// Login với email + password
  Future<Map<String, dynamic>> login(String email, String password) async {
    final Map<String, dynamic> loginData = {
      "username": email,
      "password": password,
    };
    // Mã hóa
    final jsonString = jsonEncode(
      Map.fromEntries(
        loginData.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
    );
    final encryptedPayload = EncryptionUtil.encryptString(jsonString);
    final response = await http.post(
      Uri.parse(Url.login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"data": encryptedPayload}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      final token = data['token'];
      final user = User.fromJson(data);
      await _saveToken(token);
      await _saveUser(user);
      print("Token: ${token}");

      return {"status": response.statusCode.toString(), "user": user};
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  /// Đăng ký bằng Google và thông tin bổ sung
  Future<User?> registerWithGoogle({
    required String googleToken,
    required String email,
    required String firstname,
    required String lastname,
    required String businessName,
    required String phone,
    required String country,
    required String timezone,
  }) async {
    final url = Uri.parse("$Url/register-google");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "googleToken": googleToken,
        "email": email,
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
      throw Exception("Google registration failed: ${response.body}");
    }
  }

  /// Register
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String businessName,
    required String phone,
    required String phoneCode,
    required String country,
    required String timezone,
    required String countryCode,
    required bool isReceiveNews,
    required bool isTermService,
  }) async {
    Map<String, dynamic> registerData = {
      "username": email,
      "password": password,
      "firstname": firstname,
      "lastname": lastname,
      "businessName": businessName,
      "phone": phone,
      "phoneCode": phoneCode,
      "countryName": country,
      "timezone": timezone,
      "isReceiveNews": isReceiveNews,
      "isTermService": isTermService,
      "role": "CUSTOMER",
      "describesBusiness": "",
      "describesSpecialty": "",
      "descriptionCompany": "",
      "avatar": "",
      "registrationImages": [],
      "teamSize": 1,
      "type": "INDIVIDUAL",
      "tokenWeb": "",
      "countryCode": countryCode,
    };
    print("Register Data: $registerData");
    final response = await http.post(
      Uri.parse(Url.register),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(registerData),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      print("Register Response Data: $data");
      final token = data['token'];
      final user = User.fromJson(data);
      await _saveToken(token);
      await _saveUser(user);
      return {"status": response.statusCode.toString(), "user": user};
    } else if (response.statusCode == 201) {
      return {
        "status": response.statusCode.toString(),
        "message": "Please verify your email",
      };
    } else {
      throw Exception("Register failed: ${response.body}");
    }
  }

  Future<bool> checkEmailExists(String email) async {
    final response = await http.post(
      Uri.parse("${Url.checkExistEmail}/$email"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkBusinessNameExists(String businessName) async {
    final response = await http.post(
      Uri.parse(Url.checkExistBusinessName),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"businessName": businessName}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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
