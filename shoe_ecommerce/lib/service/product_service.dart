import 'package:shoe_ecommerce/model/product_model.dart';
import 'package:shoe_ecommerce/utils/constants/apihelper.dart';

class ProductService {
  // Singleton pattern
  static final ProductService _instance = ProductService._internal();

  factory ProductService() => _instance;

  ProductService._internal();

  /// Fetch all products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await ApiHelper.get('products/all');

      if (response['success']) {
        final data = response['data'];
        if (data == null || data['data'] == null) {
          throw Exception('Invalid data structure');
        }

        final List<dynamic> productList = data['data'];
        return productList.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in getAllProducts: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  /// Get product details by ID
  Future<Product> getProductById(String productId) async {
    try {
      final response = await ApiHelper.get('products/$productId');

      if (response['success']) {
        final data = response['data'];
        return Product.fromJson(data);
      } else {
        throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in getProductById: $e');
      throw Exception('Failed to load product details: $e');
    }
  }

  /// Filter products by query params
  Future<List<Product>> filterProducts(Map<String, dynamic> queryParams) async {
    try {
      final uri = Uri.parse('products/filter').replace(queryParameters: queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      ));

      final response = await ApiHelper.get(uri.toString());

      if (response['success']) {
        final data = response['data'];
        if (data == null || data['data'] == null) {
          throw Exception('Invalid data structure');
        }

        final List<dynamic> productList = data['data'];
        return productList.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in filterProducts: $e');
      throw Exception('Failed to load filtered products: $e');
    }
  }

  /// Fetch popular products
Future<List<Product>> getPopularProducts() async {
  try {
    final response = await ApiHelper.get('products/popular');

    if (response['success']) {
      final data = response['data'];
      if (data == null || data['data'] == null) {
        throw Exception('Invalid data structure');
      }

      final List<dynamic> productList = data['data'];
      return productList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    print('Error in getPopularProducts: $e');
    throw Exception('Failed to load popular products: $e');
  }
}

  /// Fetch new arrival products
Future<List<Product>> getNewArrivals() async {
  try {
    final response = await ApiHelper.get('products/newArrivals');

    if (response['success']) {
      final data = response['data'];
      if (data == null || data['data'] == null) {
        throw Exception('Invalid data structure');
      }

      final List<dynamic> productList = data['data'];
      return productList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    print('Error in getNewArrivals: $e');
    throw Exception('Failed to load new arrival products: $e');
  }
}



}
