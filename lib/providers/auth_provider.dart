import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:picpee_mobile/models/user_model.dart';
import 'package:picpee_mobile/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  String? _token;
  bool _isLoading = false;
  
  // Google user info from Firebase
  String? _googleEmail;
  String? _googleDisplayName;
  String? _googlePhotoUrl;
  String? _googleIdToken;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null && _user != null;
  
  // Google user getters
  String? get googleEmail => _googleEmail;
  String? get googleDisplayName => _googleDisplayName;
  String? get googlePhotoUrl => _googlePhotoUrl;

  /// Initialize auth
  Future<void> initAuth() async {
    _token = await _authService.getToken();
    _user = await _authService.getUser();
    notifyListeners();
  }

  /// Regular login
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

  /// Google Sign-In for Registration (returns Google user info)
  Future<bool> signInWithGoogleForRegistration() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false; // User cancelled
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create Firebase credential
      final firebase_auth.OAuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final firebase_auth.UserCredential userCredential = 
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Store Google user info for later use in registration
        _googleEmail = userCredential.user!.email;
        _googleDisplayName = userCredential.user!.displayName;
        _googlePhotoUrl = userCredential.user!.photoURL;
        _googleIdToken = googleAuth.idToken;

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
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
      
      _user = user;
      _token = await _authService.getToken();
      
      // Clear Google temporary data
      _clearGoogleData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Regular registration
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
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    _user = null;
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
