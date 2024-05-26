import 'package:e_shop/providers/user_provider.dart';
import 'package:e_shop/widgets/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/providers/product_provider.dart';
import 'package:e_shop/service/product_service.dart';
import 'package:e_shop/ui/create_coupon.dart';
import 'package:e_shop/ui/shopping_basket_screen.dart';
import 'package:e_shop/providers/basket_provider.dart';
import 'package:e_shop/widgets/like_animation.dart';

class ProductDetailScreen extends StatefulWidget {
  final String image;
  final String productTitle;
  final String productId;
  final String productPrice;
  final String description;
  // final String condition;
  final String category;
  final String stock;
  // final String uid;
  // final likes;
  // final saveProducts;
  // String productQuantity;

  ProductDetailScreen(
    this.image,
    this.productTitle,
    this.productId,
    this.productPrice,
    this.description,
    // this.condition,
    this.category,
    this.stock,
    // this.uid,
    // this.likes,
    // this.productQuantity,
    // this.saveProducts,
  );

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService firestoreService = ProductService();

  late UserProvider UsersProvider;
  late ProductProvider productProvider;

  // late String photoUrl;
  // late String Usersname;
  // late String uid;

  @override
  void initState() {
    super.initState();
    UsersProvider = Provider.of<UserProvider>(context, listen: false);
    UsersProvider.fetchUser();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    // isLiked = widget.likes.contains(UsersProvider.getUsers.uid);
    // isSaved =
    //     widget.saveProducts.contains(FirebaseAuth.instance.currentUsers!.uid);
    isProductCheck();
  }

  isProductCheck() {
    // if (widget.productQuantity == "0") {
    //   widget.productQuantity = "Tükendi";
    // }
  }

  bool isLikeAnimating = false;
  late bool isLiked = false;
  late bool isSaved = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    final double height = screenSize.size.height;
    final double width = screenSize.size.width;

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
                            Positioned(
                              top: 50,
                              right: 10,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(2),
                                child: LikeAnimation(
                                  isAnimating: isLiked,
                                  smallLike: false,
                                  child: IconButton(
                                    icon: isLiked
                                        ? const Icon(Icons.favorite,
                                            color: Colors.red)
                                        : const Icon(Icons.favorite_border),
                                    color: getAccentColor(context),
                                    iconSize: 20,
                                    onPressed: () async {},
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
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 20,
                            ),
                            child: LikeAnimation(
                              isAnimating: isSaved,
                              smallLike: false,
                              child: IconButton(
                                icon: isSaved
                                    ? const Icon(Icons.bookmark,
                                        color: Colors.red)
                                    : const Icon(Icons.bookmark_border),
                                color: getAccentColor(context),
                                iconSize: 30,
                                onPressed: () async {
                                  // await ProductService().saveProducts(
                                  //   widget.productId,
                                  //   widget.uid,
                                  //   widget.saveProducts,
                                  // );

                                  // if (widget.saveProducts
                                  //     .contains(UsersProvider.getUsers.uid)) {
                                  //   widget.saveProducts
                                  //       .remove(UsersProvider.getUsers.uid);
                                  // } else {
                                  //   widget.saveProducts
                                  //       .add(UsersProvider.getUsers.uid);
                                  // }
                                  // setState(() {
                                  //   isSaved = widget.saveProducts
                                  //       .contains(UsersProvider.getUsers.uid);
                                  // });
                                },
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
                                  widget.stock,
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
                      // Padding(
                      //   padding: EdgeInsets.only(left: 18),
                      //   child: Text(
                      //     "Mevcut Ürün: ${widget.productQuantity} ",
                      //     style: TextStyle(
                      //       color: Colors.grey.shade600,
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      // ),
                      Divider(),
                      // Container(
                      //   width: width,
                      //   height: 100,
                      //   color: Colors.white,
                      //   child: Padding(
                      //       padding: EdgeInsets.only(
                      //           left: 18, right: 18, top: 20, bottom: 20),
                      //       child: Row(
                      //         children: [
                      //           Container(
                      //             height: 100,
                      //             width: 100,
                      //             child: CircleAvatar(
                      //               backgroundImage: NetworkImage(
                      //                 photoUrl,
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Text(
                      //                   Usersname,
                      //                   style: TextStyle(
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 16,
                      //                   ),
                      //                 ),
                      //                 GestureDetector(
                      //                     onTap: () {
                      //                       Navigator.of(context).push(
                      //                           MaterialPageRoute(
                      //                               builder: (contex) =>
                      //                                   ProfileGeneral(
                      //                                       uid: uid)));
                      //                     },
                      //                     child: Text("Satıcıyı görüntüle >")),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       )),
                      // ),
                      // Divider(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateCouponScreen()),
                          );
                        },
                        child: Container(
                          width: width,
                          height: 80,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 18, right: 18, top: 10, bottom: 10),
                            child: Text(
                              "Kuponlar & Kampanyalar",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 50, right: 10, left: 10),
                        child: Container(
                          width: width,
                          height: 80,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Ürün Soru & Cevapları",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ],
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
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check),
                      label: 'Teklif Ver',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_bag_outlined),
                      label: 'Sepete Ekle',
                    ),
                  ],
                  selectedItemColor: Colors.grey.shade600,
                  unselectedItemColor: Colors.grey.shade600,
                  onTap: (int index) {
                    if (index == 0) {
                    } else if (index == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShoppingBasketScreen()),
                      );

                      // final product = basketProduct(
                      //   image: widget.image,
                      //   title: widget.productTitle,
                      //   price: widget.productPrice,
                      //   description: widget.description,
                      //   condition: widget.condition,
                      //   category: widget.category,
                      //   size: widget.size,
                      //   uid: widget.uid,
                      //   productId: widget.productId,
                      //   productQuantity: widget.productQuantity,
                      //   count: 1,
                      // );

                      // Provider.of<BasketProvider>(context, listen: false)
                      //     .addToBasket(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ürün sepete eklendi')),
                      );
                    }
                  },
                );
              },
            ),
          );
  }
}
