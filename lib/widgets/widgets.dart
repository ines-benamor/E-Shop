import 'package:e_shop/models/products.dart';
import 'package:e_shop/ui/product_detail.dart';
import 'package:e_shop/widgets/color_data.dart';
import 'package:flutter/material.dart';

Widget buildProductItem(BuildContext context, Product product) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: greyButtonColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                product.thumbnail,
                product.title,
                product.id,
                product.price.toString(),
                product.description,
                product.category,
                product.stock,
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              product.thumbnail,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (product.price < 50)
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${(product.price % 1 == 0) ? product.price.toInt() : product.price} DT",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: redColor,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  "-${product.discountPercentage} %",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: getAccentColor(context),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${(product.price - (product.price * (product.discountPercentage! / 100))).toStringAsFixed(2)} DT",
                              style: TextStyle(
                                fontSize: 15,
                                color: getAccentColor(context),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          "${product.price} DT",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                    ],
                  ),
                  if (product.price < 10)
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Vente Flash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
