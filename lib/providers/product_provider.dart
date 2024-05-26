import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/products.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  List<String> _likedProductIds = [];

  // Fetch products and notify listeners
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
    // Filter the products based on the price range
    _products = _products.where((product) {
      double productPrice = product.price; // Assuming price is a String
      return productPrice >= minPrice && productPrice <= maxPrice;
    }).toList();
    notifyListeners(); // Notify listeners after updating products
  }

  void addToLikedProducts(String productId) {
    if (!_likedProductIds.contains(productId)) {
      _likedProductIds.add(productId);
      notifyListeners();
    }
  }

  void removeFromLikedProducts(String productId) {
    _likedProductIds.remove(productId);
    notifyListeners();
  }

  List<String> get likedProductIds => _likedProductIds;
}
