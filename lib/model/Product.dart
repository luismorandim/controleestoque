import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  List<Map<String, dynamic>> _products = [
    {'name': 'Produto A', 'quantity': 5, 'minimum': 10},
    {'name': 'Produto B', 'quantity': 7, 'minimum': 10},
    {'name': 'Produto C', 'quantity': 3, 'minimum': 10},
    {'name': 'Produto D', 'quantity': 15, 'minimum': 10},
    {'name': 'Produto E', 'quantity': 9, 'minimum': 10},
  ];

  List<Map<String, dynamic>> get products => _products;

  void addProduct(Map<String, dynamic> product) {
    _products.add(product);
    notifyListeners();
  }

  void updateQuantity(String name, int newQuantity) {
    final index = _products.indexWhere((product) => product['name'] == name);
    if (index != -1) {
      _products[index]['quantity'] = newQuantity;
      notifyListeners();
    }
  }

  void updateProduct(int index, Map<String, dynamic> updatedProduct) {
    _products[index] = updatedProduct;
    notifyListeners();
  }
}
