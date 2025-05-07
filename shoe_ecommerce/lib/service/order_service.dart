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
      final response = await ApiHelper.delete('orders/cart/remove/$productId');
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
      final Map<String, dynamic> requestBody = {
        'address': {
          'street': address,
          'city': '',
          'state': '',
          'postalCode': '',
          'country': '',
        },
        'paymentMode': paymentMode,
        'isOrderAccepted': false,
        'orderAcceptanceComment': '',
        'isInProcess': false,
        'inProcessComment': '',
        'isInTransit': false,
        'inTransitComment': '',
        'isShipped': false,
        'shippedComment': '',
        'isDelivered': false,
        'deliveredComment': '',
        'isCancelled': false,
        'cancelledComment': '',
        'isExchangeRequest': false,
        'exchangeComment': '',
        'isExchangePickup': false,
        'isReturnRequest': false,
        'returnComment': '',
        'isRefundInitiate': false,
        'isReturnPicked': false
      };

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

  /// Update order status or workflow details
  Future<Map<String, dynamic>> updateOrder(String orderId, Map<String, dynamic> updates) async {
    try {
      final response = await ApiHelper.patch('orders/$orderId', updates);
      if (response['success']) {
        return response;
      } else {
        throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in updateOrder: $e');
      throw Exception('Failed to update order: $e');
    }
  }

  /// Get orders by user ID
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await ApiHelper.get('orders/orders');
      if (response['success']) {
        final List data = response['data']['data'];
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Error: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in getOrdersByUserId: $e');
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
