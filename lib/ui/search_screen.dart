import 'package:e_shop/models/products.dart';
import 'package:e_shop/providers/price_range_provider.dart';
import 'package:e_shop/providers/product_provider.dart';
import 'package:e_shop/ui/product_detail.dart';
import 'package:e_shop/widgets/color_data.dart';
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
    final products = productProvider.products;

    if (query.isNotEmpty || (_minPrice != 0 || _maxPrice != 1000)) {
      setState(() {
        isSearching = true;
        filteredProducts = products.where((product) {
          return product.title.toLowerCase().contains(query.toLowerCase()) &&
              product.price >= _minPrice &&
              product.price <= _maxPrice;
        }).toList();
      });
    } else {
      setState(() {
        isSearching = false;
        filteredProducts = Provider.of<ProductProvider>(context, listen: false)
            .fetchProducts() as List<Product>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
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
                                min: 0,
                                max: 1000, // Set the maximum price range
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
                                  productProvider.filterProductsByPriceRange(
                                    priceRangeProvider.minPrice,
                                    priceRangeProvider.maxPrice,
                                  );
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
                      'No result',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 150, // Adjust the height as needed
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
                                    product.id.toString(),
                                    product.price.toString(),
                                    product.description,
                                    product.category,
                                    product.stock.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              // Use Row instead of Column
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  product.thumbnail,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                    width:
                                        10), // Add some space between the image and text
                                Expanded(
                                  // Use Expanded for flexible width
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(
                                          height:
                                              8), // Add some space between the title and price
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    Text(
                                                      "-${product.discountPercentage} %",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: getAccentColor(
                                                            context),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${(product.price - (product.price * (product.discountPercentage / 100))).toStringAsFixed(2)} DT",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                        getAccentColor(context),
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
                              ],
                            ),
                          ),
                        ),
                      );
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
