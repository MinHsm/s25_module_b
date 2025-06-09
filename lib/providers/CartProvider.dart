import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  bool get allSelected =>
      _cartItems.isNotEmpty &&
          _cartItems.every((item) => item['selected'] == true);

  CartProvider() {
    _loadCartFromPrefs();
  }

  void addToCart(Map<String, dynamic> item) {
    item['selected'] = true; // 默认勾选
    _cartItems.add(item);
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> item) {
    _cartItems.remove(item);
    _saveCartToPrefs();
    notifyListeners();
  }

  void toggleItemSelected(Map<String, dynamic> item, bool selected) {
    final index = _cartItems.indexOf(item);
    if (index != -1) {
      _cartItems[index]['selected'] = selected;
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  void toggleAllSelected(bool selected) {
    for (var item in _cartItems) {
      item['selected'] = selected;
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeSelectedItems() {
    _cartItems.removeWhere((item) => item['selected'] == true);
    _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedCart =
    jsonEncode(_cartItems.map((e) => Map.from(e)).toList());
    await prefs.setString('cartItems', encodedCart);
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCart = prefs.getString('cartItems');
    if (savedCart != null) {
      final decoded = jsonDecode(savedCart);
      _cartItems = List<Map<String, dynamic>>.from(decoded);
      notifyListeners();
    }
  }
}