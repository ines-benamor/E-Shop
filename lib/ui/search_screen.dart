import 'package:e_shop/models/products.dart';
import 'package:e_shop/providers/price_range_provider.dart';
import 'package:e_shop/providers/product_provider.dart';
import 'package:e_shop/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchEditingController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 1000;
  List<Product> filteredProducts = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchEditingController.addListener(() {
      filterProducts();
    });
  }

  void filterProducts() {
    final query = searchEditingController.text;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final priceRangeProvider =
        Provider.of<PriceRangeProvider>(context, listen: false);

    if (query.isNotEmpty ||
        (priceRangeProvider.minPrice != _minPrice ||
            priceRangeProvider.maxPrice != _maxPrice)) {
      setState(() {
        isSearching = true;
        filteredProducts = productProvider.products.where((product) {
          return product.title.toLowerCase().contains(query.toLowerCase()) &&
              product.price >= priceRangeProvider.minPrice &&
              product.price <= priceRangeProvider.maxPrice;
        }).toList();
      });
    } else {
      setState(() {
        isSearching = false;
        filteredProducts = productProvider.products;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: searchEditingController,
                decoration: InputDecoration(
                  labelText: "Rechercher",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Consumer<PriceRangeProvider>(
                      builder: (context, priceRangeProvider, child) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Sélectionner la plage de prix',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              RangeSlider(
                                values: RangeValues(
                                  priceRangeProvider.minPrice,
                                  priceRangeProvider.maxPrice,
                                ),
                                min: _minPrice,
                                max: _maxPrice,
                                divisions: 100,
                                labels: RangeLabels(
                                  priceRangeProvider.minPrice.toString(),
                                  priceRangeProvider.maxPrice.toString(),
                                ),
                                onChanged: (RangeValues values) {
                                  priceRangeProvider.updatePriceRange(
                                    values.start,
                                    values.end,
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  filterProducts();
                                },
                                child: Text('Filtrer'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: searchEditingController,
              style: TextStyle(fontSize: 13.0),
              decoration: InputDecoration(
                hintText: 'Recherche',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final products =
                    isSearching ? filteredProducts : productProvider.products;

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun résultat',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];

                      return buildProductItem(context, product);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
