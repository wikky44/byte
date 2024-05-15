import 'package:flutter/material.dart';
import 'Providerr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider (
      create: (_) => ProductProvider(),
      child: MaterialApp(
        home: ProductListPage(),debugShowCheckedModeBanner: false,
      ),
    );
  }
}