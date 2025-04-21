import 'package:shoe_ecommerce/model/product_model.dart';

class Cart {
  final String? id;
  final String? userId;
  final List<CartItem>? products;

  Cart({
    this.id,
    this.userId,
    this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List? ?? [];
    List<CartItem> cartItems = productsList.map((item) => CartItem.fromJson(item)).toList();

    return Cart(
      id: json['_id'],
      userId: json['user'],
      products: cartItems,
    );
  }
}

class CartItem {
  final String? cartItemId;
  final Product? product;
  final int? quantity;
  final String? size;

  CartItem({
    this.cartItemId,
    this.product,
    this.quantity,
    this.size,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['_id'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      quantity: json['quantity'],
      size: json['size'],
    );
  }
}
