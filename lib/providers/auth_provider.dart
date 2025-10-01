import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/user_model.dart';
import 'package:picpee_mobile/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null && _user != null;

  /// Khởi tạo: load token + user từ storage
  Future<void> initAuth() async {
    _token = await _authService.getToken();
    _user = await _authService.getUser();
    notifyListeners();
  }

  /// Login
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      _user = user;
      _token = await _authService.getToken();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login SSO
  Future<void> loginSSO(String googleToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.loginSSO(googleToken);
      _user = user;
      _token = await _authService.getToken();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register
  Future<void> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String businessName,
    required String phone,
    required String country,
    required String timezone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.register(
        email: email,
        password: password,
        firstname: firstname,
        lastname: lastname,
        businessName: businessName,
        phone: phone,
        country: country,
        timezone: timezone,
      );
      _user = user;
      _token = await _authService.getToken();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _token = null;
    notifyListeners();
  }
}
