import 'package:e_shop/models/products.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Product> basketItems;
  final List<int> counts;
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
        title: Text('Validation de commande'),
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
                  subtitle: Text('Quantité : $count'),
                  trailing: Text('Total : ${product.price * count}'),
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
                  'Total :',
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
            onPressed: () {},
            child: Text('Procéder au paiement'),
          ),
        ],
      ),
    );
  }
}
