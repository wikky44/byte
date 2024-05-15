import 'dart:convert';

import '../Model/Productss.dart';
import '../main.dart';

class ProductService {
  static const String baseUrl = 'https://my-store.in/v2/products/api/getProductsList';

  static get http => null;

  static Future<List<Product>> fetchProducts(int page) async {
    final response = await http.post(Uri.parse(baseUrl),
      headers: {'appid': '2IPbyrCUM7s5JZhnB9fxFAD6'},
      body: {'page': page.toString()},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Product> products = [];
      for (var item in jsonData['products']) {
        products.add(Product.fromJson(item));
      }
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
