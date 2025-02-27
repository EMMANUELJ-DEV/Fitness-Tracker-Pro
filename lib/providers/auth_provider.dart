import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _userId = '';
  String _userEmail = '';
  String _userName = '';

  // Store registered users locally
  final Map<String, Map<String, dynamic>> _users = {
    'test@gmail.com': {
      'password': 'test123',
      'name': 'Test User',
      'profile': {
        'phone': '+1234567890',
        'age': '25',
        'gender': 'Male',
        'height': 175.0,
        'weight': 70.0,
        'fitness_goal': 'Weight Loss',
      }
    }
  };

  bool get isAuthenticated => _isAuthenticated;
  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;

  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String age,
    required String gender,
    required double height,
    required double weight,
    required String fitnessGoal,
    required Map<String, dynamic> userData,
  }) async {
    try {
      // Basic validation
      if (!email.contains('@gmail.com')) {
        throw 'Please use a Gmail address';
      }

      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      if (_users.containsKey(email)) {
        throw 'Email already registered';
      }

      // Store new user
      _users[email] = {
        'password': password,
        'name': name,
        'profile': {
          'phone': phone,
          'age': age,
          'gender': gender,
          'height': height,
          'weight': weight,
          'fitness_goal': fitnessGoal,
        }
      };

      // Auto login after registration
      _isAuthenticated = true;
      _userId = DateTime.now().millisecondsSinceEpoch.toString();
      _userEmail = email;
      _userName = name;
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      // Basic validation
      if (email.isEmpty || password.isEmpty) {
        throw 'Please fill in all fields';
      }

      // Simple email validation
      if (!email.contains('@')) {
        throw 'Please enter a valid email address';
      }

      // Simple password validation
      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Set authentication state
      _isAuthenticated = true;
      _userId = DateTime.now().millisecondsSinceEpoch.toString();
      _userEmail = email;
      _userName = email.split('@')[0];
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    _userId = '';
    _userEmail = '';
    _userName = '';
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      // Mock implementation only
      _isAuthenticated = true;
      _userId = 'google_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = 'google.user@gmail.com';
      _userName = 'Google User';
      notifyListeners();
    } catch (e) {
      throw 'Failed to sign in with Google';
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      // Mock implementation only
      _isAuthenticated = true;
      _userId = 'fb_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = 'facebook.user@gmail.com';
      _userName = 'Facebook User';
      notifyListeners();
    } catch (e) {
      throw 'Failed to sign in with Facebook';
    }
  }

  Future<void> signInWithPhone(String phone) async {
    // Simulate phone verification
    return;
  }

  Future<bool> verifyOTP(String phone, String otp) async {
    if (otp == '123456') {
      _isAuthenticated = true;
      _userId = 'phone_${DateTime.now().millisecondsSinceEpoch}';
      _userName = 'Phone User';
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> resetPassword(String email) async {
    if (!_users.containsKey(email)) {
      throw 'Email not registered';
    }
    // Simulate password reset
    return;
  }
} 