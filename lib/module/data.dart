import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CarData {
  final String name;
  final String imgPath;
  final String description;
  final double price;
  final double rating;

  CarData(
      {required this.name,
      required this.imgPath,
      required this.description,
      required this.price,
      required this.rating});
}

class User {
  final String email;
  final String password;
  final String? verificationCode;

  User({
    required this.email,
    required this.password,
    this.verificationCode,
  });
}

class UserService {
  static const String userKey = 'registered_users';

  /// 保存注册用户
  static Future<void> register(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await loadUsers();

    // 防止重复注册
    if (users.any((u) => u['email'] == user.email)) return;

    users.add({
      'email': user.email,
      'password': user.password,
    });

    await prefs.setString(userKey, jsonEncode(users));
  }

  /// 登录验证
  static Future<User?> login(String email, String password) async {
    final users = await loadUsers();
    final matched = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => <String, dynamic>{});

    if (matched.isNotEmpty) {
      final user = User(email: matched['email'], password: matched['password']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      print('登录成功，已设置 isLoggedIn = true');
      await prefs.setString('loggedInEmail', user.email);

      return user;
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(userKey);
    if (jsonStr == null) return [];
    final decoded = jsonDecode(jsonStr);
    return List<Map<String, dynamic>>.from(decoded);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('loggedInEmail');
  }

  static Future<String?> getLoggedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInEmail');
  }

}
