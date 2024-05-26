import 'package:e_shop/ui/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/providers/basket_provider.dart';
import 'package:e_shop/service/auth.dart';
import 'package:e_shop/ui/product_detail.dart';
import 'package:e_shop/widgets/color_data.dart';

class ShoppingBasketScreen extends StatefulWidget {
  @override
  State<ShoppingBasketScreen> createState() => _ShoppingBasketScreenState();
}

class _ShoppingBasketScreenState extends State<ShoppingBasketScreen> {
  final AuthService authService = AuthService();
  int _selectedIndex = 0;
  bool deleteItem = false;
  var total = 0.0;

  late String? userId;
  late List<int> counts;

  Future<void> fetchData() async {
    userId = await authService.getCurrentUserId();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    counts = List.filled(context.read<BasketProvider>().basketItems.length, 1);
  }

  Future<void> _onItemTapped(int index) async {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            basketItems: context.read<BasketProvider>().basketItems,
            counts: counts,
            total: total,
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon Panier"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<BasketProvider>(
        builder: (context, basketProvider, child) {
          if (basketProvider.basketItems.isEmpty) {
            total = 0.0;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Votre panier est vide"),
              ),
            );
          }

          total = basketProvider.basketItems
              .map((item) =>
                  item.price * counts[basketProvider.basketItems.indexOf(item)])
              .reduce((value, element) => value + element);

          return Column(
            children: [
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: basketProvider.basketItems.length,
                  itemBuilder: (context, index) {
                    var item = basketProvider.basketItems[index];
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
                                  item.thumbnail,
                                  item.title,
                                  item.id,
                                  item.price.toString(),
                                  item.description,
                                  item.category,
                                  item.stock,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                item.thumbnail,
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
                                      item.title,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${item.price} DT",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Quantité: ${counts[index]}"),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (counts[index] < item.stock) {
                                                counts[index]++;
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "La quantité dépasse le stock disponible ou il n'y a pas assez de produit en stock!"),
                                                ));
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 15, left: 1),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (counts[index] > 1) {
                                                  counts[index]--;
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.minimize),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  total -= item.price * item.stock;
                                  basketProvider.removeFromBasket(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
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
                      '${total.toStringAsFixed(2)}DT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.transparent),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Valider le panier',
            backgroundColor: Colors.pinkAccent,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
