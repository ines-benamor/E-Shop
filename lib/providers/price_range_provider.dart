import 'package:flutter/foundation.dart';

class PriceRangeProvider extends ChangeNotifier {
  double _minPrice = 0;
  double _maxPrice = 1000;

  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  void updatePriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }
}
