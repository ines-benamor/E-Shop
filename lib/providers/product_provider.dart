import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/products.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _products = (data['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void filterProductsByPriceRange(double minPrice, double maxPrice) {
    _products = _products.where((product) {
      double productPrice = product.price;
      return productPrice >= minPrice && productPrice <= maxPrice;
    }).toList();
    notifyListeners();
  }
}
