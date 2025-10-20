import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picpee_mobile/providers/user_provider.dart';
import 'package:picpee_mobile/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserProvider _userProvider = UserProvider();
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? _token;
  bool _isLoading = false;

  // Google user info from Firebase
  String? _googleEmail;
  String? _googleDisplayName;
  String? _googlePhotoUrl;
  String? _googleIdToken;

  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null;

  // Google user getters
  String? get googleEmail => _googleEmail;
  String? get googleDisplayName => _googleDisplayName;
  String? get googlePhotoUrl => _googlePhotoUrl;

  /// Initialize auth
  Future<void> initAuth() async {
    _token = await _authService.getToken();
    notifyListeners();
  }

  /// Regular login
  Future<int> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _authService.login(email, password);
      final status = res["status"];
      if (status != "200") {
        return int.parse(status);
      }
      _token = await _authService.getToken();
      // User user = res["user"];
      // _userProvider.setUser(user);
      return int.parse(status);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogleForRegistration() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Lấy Google authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Lưu thông tin từ Google
      _googleEmail = googleUser.email;
      _googleDisplayName = googleUser.displayName;
      _googlePhotoUrl = googleUser.photoUrl;
      _googleIdToken = googleAuth.idToken;

      // In thông tin để debug
      print("Google Email: $_googleEmail");
      print("Google Name: $_googleDisplayName");
      print("Google ID Token: ${_googleIdToken?.substring(0, 20)}...");

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Google sign-in error: $e");
      _isLoading = false;
      notifyListeners();
      throw Exception("Google sign-in failed: $e");
    }
  }

  /// Complete registration with Google + additional info
  Future<void> registerWithGoogle({
    required String firstname,
    required String lastname,
    required String businessName,
    required String phone,
    required String country,
    required String timezone,
  }) async {
    if (_googleEmail == null || _googleIdToken == null) {
      throw Exception("No Google authentication data available");
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Register with your backend using Google token + additional info
      final user = await _authService.registerWithGoogle(
        googleToken: _googleIdToken!,
        email: _googleEmail!,
        firstname: firstname,
        lastname: lastname,
        businessName: businessName,
        phone: phone,
        country: country,
        timezone: timezone,
      );

      _token = await _authService.getToken();

      // Clear Google temporary data
      _clearGoogleData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Regular registration
  Future<String> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String businessName,
    required String phone,
    required String country,
    required String timezone,
    required bool isReceiveNews,
    required bool isTermService,
    required String phoneCode,
    required String countryCode,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _authService.register(
        email: email,
        password: password,
        firstname: firstname,
        lastname: lastname,
        businessName: businessName,
        phone: phone,
        country: country,
        timezone: timezone,
        isReceiveNews: isReceiveNews,
        isTermService: isTermService,
        phoneCode: phoneCode,
        countryCode: countryCode,
      );
      final status = res["status"];
      _token = await _authService.getToken();
      return status;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistEmail(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final exists = await _authService.checkEmailExists(email);
      return exists;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistBusinessName(String businessName) async {
    _isLoading = true;
    notifyListeners();
    try {
      final exists = await _authService.checkBusinessNameExists(businessName);
      return exists;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    _userProvider.clearUser();
    _token = null;
    _clearGoogleData();
    notifyListeners();
  }

  void _clearGoogleData() {
    _googleEmail = null;
    _googleDisplayName = null;
    _googlePhotoUrl = null;
    _googleIdToken = null;
  }
}
