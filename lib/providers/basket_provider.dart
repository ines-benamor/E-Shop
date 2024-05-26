import 'package:e_shop/models/products.dart';
import 'package:flutter/material.dart';

class BasketProvider with ChangeNotifier {
  List<Product> _basketItems = [];

  List<Product> get basketItems => _basketItems;

  void addToBasket(Product item) {
    int index =
        _basketItems.indexWhere((basketItem) => basketItem.id == item.id);
    if (index >= 0) {
      _basketItems[index].stock += item.stock;
    } else {
      _basketItems.add(item);
    }
    notifyListeners();
  }

  void removeFromBasket(int index) {
    _basketItems.removeAt(index);
    notifyListeners();
  }

  void incrementItemCount(int index) {
    _basketItems[index].stock += 1;
    notifyListeners();
  }

  void decrementItemCount(int index) {
    if (_basketItems[index].stock > 1) {
      _basketItems[index].stock -= 1;
      notifyListeners();
    }
  }
}
