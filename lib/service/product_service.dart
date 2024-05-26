import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_shop/models/products.dart';
import 'package:e_shop/models/users.dart' as model;
import 'package:e_shop/service/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService auth = AuthService();

  Future<void> addProductToBasket(
      int userId, int productId, int quantity) async {
    final url = Uri.parse('https://dummyjson.com/carts/add');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'userId': userId,
      'products': [
        {
          'id': productId,
          'quantity': quantity,
        },
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);
    } else {
      print('Failed to add product to basket: ${response.reasonPhrase}');
    }
  }

  Future<model.User> getUserData() async {
    try {
      User currentUser = _auth.currentUser!;
      String email = currentUser.email!;

      final url =
          Uri.parse('http://dummyjson.com/users/filter?key=email&value=$email');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData.isNotEmpty) {
          Map<String, dynamic> userData = responseData[0];

          return model.User.fromJson(userData);
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw e;
    }
  }

  final String _baseUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> productsJson = data['products'];
      print("Fetched products: $productsJson");
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      print('Failed to load products');
      return [];
    }
  }
}
