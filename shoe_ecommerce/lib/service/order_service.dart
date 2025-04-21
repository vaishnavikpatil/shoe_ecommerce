
import 'package:shoe_ecommerce/model/cart_model.dart';
import 'package:shoe_ecommerce/utils/constants/apihelper.dart';

class OrderService {
  // Singleton pattern
  static final OrderService _instance = OrderService._internal();

  factory OrderService() => _instance;

  OrderService._internal();

  /// Fetch cart items
  Future<Cart> getCart() async {
    try {
      final response = await ApiHelper.get('orders/cart');

      if (response['success']) {
        final data = response['data']['data'];
   
        return Cart.fromJson(data); 
      } else {
        throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in getCart: $e');
      throw Exception('Failed to fetch cart: $e');
    }
  }

  /// Add a product to the cart
  Future<Map<String, dynamic>> addToCart(String productId, String size, int quantity) async {
    try {
      final response = await ApiHelper.post('orders/cart/add', {
        'productId': productId,
        'size': size,
        'quantity': quantity,
      });

      if (response['success']) {
        return response;
      } else {
        throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in addToCart: $e');
      throw Exception('Failed to add product to cart: $e');
    }
  }

  /// Remove item from the cart
 Future<Map<String, dynamic>> removeFromCart(String productId) async {
  try {
    final response = await ApiHelper.delete('orders/cart/remove/$productId'); // Pass productId in the URL

    if (response['success']) {
      return response;
    } else {
      throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    print('Error in removeFromCart: $e');
    throw Exception('Failed to remove product from cart: $e');
  }
}


  /// Update the quantity of a product in the cart
  Future<Map<String, dynamic>> updateCartQuantity(String productId, int quantity) async {
    try {
      final response = await ApiHelper.post('orders/updateCart', {
        'productId': productId,
        'quantity': quantity,
      });

      if (response['success']) {
        return response;
      } else {
        throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in updateCartQuantity: $e');
      throw Exception('Failed to update cart quantity: $e');
    }
  }

  /// Checkout
Future<Map<String, dynamic>> checkout(String address, String paymentMode) async {
  try {
    // Create the body data for the request, passing the address and payment mode
    final Map<String, dynamic> requestBody = {
      'address': address,
      'paymentMode': paymentMode,
    };

    // Make the POST request to the API
    final response = await ApiHelper.post('orders/order/place', requestBody);

    if (response['success']) {
      return response;
    } else {
      throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    print('Error in checkout: $e');
    throw Exception('Failed to checkout: $e');
  }
}

}
