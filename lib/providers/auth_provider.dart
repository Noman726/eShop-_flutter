import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  UserResponseDTO? _user;
  final ApiService _apiService = ApiService();
  bool isAuthenticated = false;

  UserResponseDTO? get user => _user;

  // Add method to simulate login for bypass mode
  void simulateLogin(String email) {
    _user = UserResponseDTO(
      id: 'bypass-user',
      name: 'Demo User',
      email: email,
      role: 'BUYER',
    );
    isAuthenticated = true;
    notifyListeners(); // This is crucial!
  }

  // Add method to simulate registration
  void simulateRegister(String name, String email, String role) {
    _user = UserResponseDTO(
      id: 'bypass-user',
      name: name,
      email: email,
      role: role,
    );
    isAuthenticated = true;
    notifyListeners(); // This is crucial!
  }

  Future<void> login(String email, String password) async {
    final authResponse = await _apiService.login(email, password);
    _user = authResponse.user;
    isAuthenticated = true;
    notifyListeners();
  }

  // ✅ FIXED register() method: no auto-login after registration
  Future<void> register(CreateUserDTO userDTO) async {
    await _apiService.register(userDTO);
    // Do NOT set _user or isAuthenticated
    // Let the user log in manually after successful registration
  }

  Future<void> logout() async {
    _user = null;
    isAuthenticated = false;
    await FlutterSecureStorage().deleteAll();
    notifyListeners();
  }

  Future<void> refreshToken() async {
    final authResponse = await _apiService.refreshToken();
    _user = authResponse.user;
    notifyListeners();
  }

  String getDashboardRoute() {
    switch (_user?.role) {
      case 'ADMIN':
        return '/dashboard/admin';
      case 'BUYER':
        return '/dashboard';
      case 'SELLER':
        return '/dashboard/seller';
      default:
        return '/dashboard';
    }
  }
}
