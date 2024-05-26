import 'package:flutter/foundation.dart';

class PriceRangeProvider extends ChangeNotifier {
  double _minPrice = 0;
  double _maxPrice = 1000; // Set default maximum price

  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  // Method to update range price
  void updatePriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners(); // Notify listeners after updating values
  }
}
