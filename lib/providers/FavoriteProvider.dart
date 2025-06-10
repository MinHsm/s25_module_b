import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteProvider with ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  FavoriteProvider() {
    _loadFavorites(); // 构造时加载
  }

  bool isFavorited(Map<String, dynamic> product) {
    return _favorites.any((item) => item['id'] == product['id']);
  }

  void toggleFavorite(Map<String, dynamic> product) {
    final exists = isFavorited(product);
    if (exists) {
      _favorites.removeWhere((item) => item['id'] == product['id']);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
    _saveFavorites(); // 每次更改都保存
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _favorites.map((item) => json.encode(item)).toList();
    await prefs.setStringList('favorites', jsonList);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('favorites') ?? [];
    _favorites = jsonList.map((item) => json.decode(item)).cast<Map<String, dynamic>>().toList();
    notifyListeners();
  }
}