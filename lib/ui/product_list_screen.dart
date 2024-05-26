import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/providers/product_provider.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder(
        future: productProvider.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (ctx, i) {
                final product = productProvider.products[i];
                return ListTile(
                  title: Text(product.title),
                  // subtitle: Text('\$${product.price}'),
                  trailing: IconButton(
                    icon: Icon(
                      productProvider.likedProductIds
                              .contains(product.id.toString())
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () {
                      if (productProvider.likedProductIds
                          .contains(product.id.toString())) {
                        productProvider
                            .removeFromLikedProducts(product.id.toString());
                      } else {
                        productProvider
                            .addToLikedProducts(product.id.toString());
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
