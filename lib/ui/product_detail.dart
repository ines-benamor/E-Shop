import 'package:e_shop/models/products.dart';
import 'package:e_shop/widgets/color_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/providers/product_provider.dart';
import 'package:e_shop/service/product_service.dart';
import 'package:e_shop/providers/basket_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String image;
  final String productTitle;
  final int productId;
  final String productPrice;
  final String description;
  final String category;
  final int stock;

  ProductDetailScreen(
    this.image,
    this.productTitle,
    this.productId,
    this.productPrice,
    this.description,
    this.category,
    this.stock,
  );

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService firestoreService = ProductService();

  late ProductProvider productProvider;

  late Product product;
  @override
  void initState() {
    super.initState();

    productProvider = Provider.of<ProductProvider>(context, listen: false);
    product = Product(
        id: widget.productId,
        title: widget.productTitle,
        description: widget.description,
        category: widget.category,
        price: double.parse(widget.productPrice),
        stock: widget.stock,
        thumbnail: widget.image);
  }

  bool isLikeAnimating = false;
  late bool isLiked = false;
  late bool isSaved = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.image,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 50,
                              left: 10,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(2),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: getAccentColor(context),
                                    iconSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            widget.productTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              widget.productPrice + " DT",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: Icon(
                              Icons.local_offer_outlined,
                              color: getAccentColor(context),
                            ),
                          ),
                          Text(
                            "Catégorie: ",
                            style: TextStyle(
                              color: getAccentColor(context),
                            ),
                          ),
                          Text(
                            widget.category,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Row(
                              children: [
                                Text(
                                  "Quantité: ",
                                  style: TextStyle(
                                    color: getAccentColor(context),
                                  ),
                                ),
                                Text(
                                  "${widget.stock}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, top: 10, bottom: 20),
                        child: Text(
                          widget.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: Consumer<BasketProvider>(
              builder:
                  (BuildContext context, BasketProvider value, Widget? child) {
                return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check, color: Colors.transparent),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_shopping_cart),
                      label: 'Ajouter au panier',
                    ),
                  ],
                  selectedItemColor: Colors.grey.shade600,
                  unselectedItemColor: Colors.grey.shade600,
                  onTap: (int index) {
                    final basketProvider =
                        Provider.of<BasketProvider>(context, listen: false);
                    basketProvider.addToBasket(product);

                    Fluttertoast.showToast(
                      msg: "${product.title} ajouté au panier",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                );
              },
            ),
          );
  }
}
