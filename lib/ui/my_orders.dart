import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/models/purchased.dart';
import 'package:e_shop/providers/purchased_provider.dart';
import 'package:e_shop/service/auth.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final AuthService authService = AuthService();

  String? UsersId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    UsersId = await authService.getCurrentUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (UsersId == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Siparişlerim"),
      ),
      body: Consumer<PurchasedItemsProvider>(
        builder: (context, purchasedItemsProvider, child) {
          return StreamBuilder<QuerySnapshot>(
            stream: purchasedItemsProvider.getPurchasedItemsStream(UsersId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<PurchasedItem> purchasedItems = snapshot.data!.docs
                  .map((QueryDocumentSnapshot<Object?> document) =>
                      PurchasedItem.fromJson(
                          document.data() as Map<String, dynamic>))
                  .toList();

              if (purchasedItems.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Henüz bir sipariş verilmemiş."),
                  ),
                );
              }

              return ListView.builder(
                itemCount: purchasedItems.length,
                itemBuilder: (context, index) {
                  var item = purchasedItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Image.network(
                        item.image,
                        width: 60.0,
                        height: 80.0,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(item.category),
                          Text("${item.price}DT"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
