import 'package:flutter/material.dart';

class LoginManager with ChangeNotifier {
  final List<Map<String, dynamic>> _users = [
    {
      'username': 'admin',
      'password': '123456',
      'admin': true,
      'name': 'Lulis',
    },
    {
      'username': 'user',
      'password': '123456',
      'admin': false,
      'name': 'Usuário Teste',
    },
  ];

  Map<String, dynamic>? _loggedInUser;

  Map<String, dynamic>? get loggedInUser => _loggedInUser;

  bool login(String username, String password) {
    final user = _users.firstWhere(
          (user) => user['username'] == username && user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      _loggedInUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _loggedInUser = null;
    notifyListeners();
  }
}
