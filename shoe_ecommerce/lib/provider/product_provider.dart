// import 'package:flutter/material.dart';
// import 'package:shoe_ecommerce/model/product_model.dart';
// import 'package:shoe_ecommerce/service/product_service.dart';


// class ProductProvider with ChangeNotifier {
//   List<Product> _products = [];
//   List<Product> get products => _products;

//   // Fetch products from the ProductService
//   Future<void> fetchProducts() async {
//     try {
//       final productService = ProductService();
//       final response = await productService.fetchProducts();  // Get the response
//       if (response['success']) {
//         List<dynamic> productList = response['data'];  // Ensure 'data' is a List
//         _products = productList.map((item) => Product.fromJson(item)).toList();
//         notifyListeners();
//       } else {
//         throw Exception('Failed to load products');
//       }
//     } catch (error) {
//       throw error;
//     }
//   }
// }
