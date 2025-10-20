import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/user_model.dart';
import 'package:picpee_mobile/services/user_service.dart';
import 'package:picpee_mobile/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  User? _user;

  User? get user => _user;
  bool get isLoading => _isLoading;

  /// Initialize user
  Future<void> initUser() async {
    _user = await _authService.getUser();
    print('Initialized user: ${_user.toString()}');
    notifyListeners();
  }

  /// Set user
  void setUser(User user) {
    _user = user;
    print('User set: ${_user.toString()}');
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Update user profile
  Future<bool> updateUserProfile(int userId, Map<String, dynamic> data) async {
    if (_user == null) return false;
    setLoading(true);
    try {
      final updatedUser = await _userService.updateProfile(userId, data);
      if (updatedUser != null) {
        _user = updatedUser;
        notifyListeners();
        return true;
      }
    } finally {
      setLoading(false);
    }
    return false;
  }
}
