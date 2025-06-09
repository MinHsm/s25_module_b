import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  bool isFavorited(Map<String, dynamic> product) {
    return _favorites.any((item) => item['id'] == product['id']);
  }

  void toggleFavorite(Map<String, dynamic> product) {
    final existingIndex = _favorites.indexWhere((item) => item['id'] == product['id']);
    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
}