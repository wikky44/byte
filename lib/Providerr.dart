import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Api/Api_service.dart';
import 'Model/Productss.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts(int page) async {
    try {
      List<Product> fetchedProducts = (await ProductService.fetchProducts(page)).cast<Product>();
      _products.addAll(fetchedProducts);
      notifyListeners();
    } catch (error) {
      print('Error fetching products: $error');
    }
  }
}


class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;

  var Provider;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadProducts();
    }
  }

  void _loadProducts() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts(_page);
    _page++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Listing'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          if (productProvider.products.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                if (index.isOdd) return Divider();
                final product1 = productProvider.products[index];
                final product2 = index + 1 < productProvider.products.length
                    ? productProvider.products[index + 1]
                    : null;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ProductCard(product: product1),
                      ),
                      if (product2 != null) Expanded(child: ProductCard(product: product2)),
                    ],
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

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('\$${product.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}