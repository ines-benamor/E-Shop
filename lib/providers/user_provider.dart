// ignore_for_file: unnecessary_type_check

import 'package:e_shop/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/models/users.dart';
import 'package:e_shop/service/product_service.dart';

class UserProvider with ChangeNotifier {
  User _user = const User(
    username: 'null',
    uid: 'null',
    email: 'null',
    name: 'null',
    surname: 'null',
  );

  ProductService _productService = ProductService();

  User get getUser => _user;
  final AuthService _authService = AuthService();

  Future<void> fetchUserByEmail(String email) async {
    try {
      final userData = await _authService.getUserByEmail(email);
      _user = User.fromJson(userData);
      notifyListeners();
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> fetchUser() async {
    try {
      var userData = await _productService.getUserData();
      if (userData is User) {
        _user = userData;
      } else {
        print(
            "getUserData method should return User type. Received type: ${userData.runtimeType}");
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
