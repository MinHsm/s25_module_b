import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// article_store.dart
List<Map<String, dynamic>> publishedArticles = [];

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
  final String? username;
  final String? avatarPath;

  User({
    required this.email,
    required this.password,
    this.verificationCode,
    this.username,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'username': username ?? '未命名用户',
      'avatarPath': avatarPath ?? 'assets/user_avatar/user.png',
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      username: map['username'] ?? '未命名用户',
      avatarPath: map['avatarPath'] ?? 'assets/user_avatar/user.png',
    );
  }
}

class UserService {
  static const String userKey = 'registered_users';

  /// 注册新用户（带默认头像和用户名）
  static Future<void> register(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await loadUsers();

    // 防止重复注册
    if (users.any((u) => u['email'] == user.email)) return;

    users.add(user.toMap());
    await prefs.setString(userKey, jsonEncode(users));
  }

  /// 登录验证
  static Future<User?> login(String email, String password) async {
    final users = await loadUsers();
    final matched = users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
      orElse: () => <String, dynamic>{},
    );

    if (matched.isNotEmpty) {
      final user = User.fromMap(matched);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedInEmail', user.email);
      return user;
    }
    return null;
  }

  /// 加载所有用户
  static Future<List<Map<String, dynamic>>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(userKey);
    if (jsonStr == null) return [];
    final decoded = jsonDecode(jsonStr);
    return List<Map<String, dynamic>>.from(decoded);
  }

  /// 登出
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('loggedInEmail');
  }

  /// 获取当前登录的用户邮箱
  static Future<String?> getLoggedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInEmail');
  }

  /// 检查邮箱是否已注册
  static Future<bool> isEmailRegistered(String email) async {
    final users = await loadUsers();
    return users.any((u) => u['email'] == email);
  }

  /// 更新密码
  static Future<void> updatePassword(String email, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await loadUsers();

    for (var user in users) {
      if (user['email'] == email) {
        user['password'] = newPassword;
      }
    }

    await prefs.setString(userKey, jsonEncode(users));
  }

  /// 更新用户名或头像路径
  static Future<void> updateProfile(String email,
      {String? newUsername, String? newAvatarPath}) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await loadUsers();

    for (var user in users) {
      if (user['email'] == email) {
        if (newUsername != null) user['username'] = newUsername;
        if (newAvatarPath != null) user['avatarPath'] = newAvatarPath;
      }
    }

    await prefs.setString(userKey, jsonEncode(users));
  }

  /// 获取当前登录用户信息
  static Future<User?> getCurrentUser() async {
    final email = await getLoggedInEmail();
    if (email == null) return null;

    final users = await loadUsers();
    final userMap = users.firstWhere((u) => u['email'] == email, orElse: () => {});
    if (userMap.isEmpty) return null;

    return User.fromMap(userMap);
  }
}
