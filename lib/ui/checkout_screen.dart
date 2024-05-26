// New Screen Widget to Display Shopping Basket Items
import 'package:e_shop/models/products.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Product>
      basketItems; // Assuming Product is the type of items in the basket
  final List<int> counts; // List to hold the count for each item
  final double total;

  const CheckoutScreen({
    required this.basketItems,
    required this.counts,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: basketItems.length,
              itemBuilder: (context, index) {
                final product = basketItems[index];
                final count = counts[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('Quantity: $count'),
                  trailing: Text(
                      'Total: ${product.price * count}'), // Assuming price is stored in product
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle the checkout process here
              // You can navigate to a confirmation screen or perform any other action
            },
            child: Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }
}
