import 'dart:async';
import 'package:e_shop/providers/user_provider.dart';
import 'package:e_shop/ui/product_detail.dart';
import 'package:e_shop/ui/product_list_screen.dart';
import 'package:e_shop/ui/profile-screen.dart';
import 'package:e_shop/ui/search_screen.dart';
import 'package:e_shop/ui/shopping_basket_screen.dart';
import 'package:e_shop/widgets/color_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/models/products.dart';
import 'package:e_shop/providers/product_provider.dart';
import 'package:e_shop/service/auth.dart';
import 'package:e_shop/service/product_service.dart';
import 'package:e_shop/providers/basket_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();
  final ProductService productService = ProductService();
  late Future<List<Product>> UsersProducts;
  late Future<String?> Usersname;

  late var UsersData;
  late UserProvider UsersProvider;

  @override
  void initState() {
    super.initState();
    UsersProducts = productService.fetchProducts();
    getUsersData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });

    UsersProvider = Provider.of<UserProvider>(context, listen: false);
    UsersProvider.fetchUser();
  }

  Future<void> getUsersData() async {
    UsersData = await productService.getUserData();
    setState(() {});
  }

  bool isLikeAnimating = false;

  Color myColor = Color(0xFFF3E9E0);

  bool isNewProduct(DateTime createdAt) {
    DateTime now = DateTime.now();

    int differenceInDays = now.difference(createdAt).inDays;

    return differenceInDays <= 3;
  }

  final TextEditingController searchEditingController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getAccentColor(context),
        title: Text("E-Shop", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShoppingBasketScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    email: FirebaseAuth.instance.currentUser!.email!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: TextField(
                controller: searchEditingController,
                style: TextStyle(fontSize: 13.0),
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Recherche',
                  contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 25.0,
                    color: Colors.grey.shade600,
                  ),
                ),
                onSubmitted: (_) {
                  setState(() {
                    isShowUsers = true;
                  });
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Row(
                children: [
                  Text(
                    "Produits",
                    style: TextStyle(
                      color: getAccentColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Voir tous",
                      style: TextStyle(
                        color: getAccentColor(context),
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.products.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: getAccentColor(context),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: productProvider.products.take(5).map((product) {
                        bool isNew = isNewProduct(product.meta!.createdAt);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (isNew)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: redBgColor,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.0),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Nouveau',
                                            style: TextStyle(
                                              color: redFontColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      Image.network(
                                        product.thumbnail,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 6),
                                        child: Text(
                                          product.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 5, left: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            (product.price < 50)
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${(product.price % 1 == 0) ? product.price.toInt() : product.price} DT",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: redColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          ),
                                                          if (product.price <
                                                              50)
                                                            Text(
                                                              "-${product.discountPercentage} %",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    getAccentColor(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      if (product.price < 50)
                                                        Text(
                                                          "${(product.price - (product.price * (product.discountPercentage! / 100))).toStringAsFixed(2)} DT",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                getAccentColor(
                                                                    context),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                    ],
                                                  )
                                                : Text(
                                                    "${product.price} DT",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      if (product.price < 10)
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.add_shopping_cart),
                                    onPressed: () {
                                      final basketProvider =
                                          Provider.of<BasketProvider>(context,
                                              listen: false);
                                      basketProvider.addToBasket(product);

                                      Fluttertoast.showToast(
                                        msg:
                                            "${product.title} ajouté au panier",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black87,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
