import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/models/purchased.dart';
import 'package:e_shop/service/product_service.dart';

class PurchasedItemsProvider extends ChangeNotifier {
  List<PurchasedItem> _purchasedItems = [];

  List<PurchasedItem> get purchasedItems => _purchasedItems;

  final ProductService productService = ProductService();

  /*
  void addPurchasedItem(PurchasedItem item) {
    _purchasedItems.add(item);
    notifyListeners();
  }*/

  void addPurchasedItem(PurchasedItem item, String UsersId) {
    _purchasedItems.add(item);
    productService.addOrder(
        UsersId, item.toJson()); // Firestore'a siparişi ekle
    notifyListeners();
  }

  Stream<QuerySnapshot<Object?>> getPurchasedItemsStream(String UsersId) {
    return productService.getOrdersStream(UsersId);
  }
}
