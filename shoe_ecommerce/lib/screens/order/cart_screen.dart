import 'package:shoe_ecommerce/export.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final OrderService _orderService = OrderService();
  bool isLoading = true;
  Cart cart = Cart();

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    setState(() => isLoading = true);
    try {
      Cart data = await _orderService.getCart();
      setState(() {
        cart = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
     
    }
  }

  double getTotalAmount() {
    double total = 0.0;
    for (var item in cart.products ?? []) {
      total += item.product!.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leadingIcon: Icons.arrow_back_ios,
      onLeadingTap: () => context.pop(),
      apptitle: "My Cart",
      centerTitle: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (cart.products == null || cart.products!.isEmpty)
              ? const Center(child: Text("Your cart is empty"))
              : Column(
                  children: [
                    Expanded(
                      child: CartItemList(
                        cart: cart,
                        onItemRemoved: _fetchCartItems,
                      ),
                    ),
                    CheckoutSection(totalAmount: getTotalAmount()),
                  ],
                ),
    );
  }
}

class CartItemList extends StatelessWidget {
  final Cart cart;
  final VoidCallback onItemRemoved;

  const CartItemList({super.key, required this.cart, required this.onItemRemoved});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cart.products!.length,
      itemBuilder: (context, index) {
        final item = cart.products![index];
        return CartItemTile(
          item: {
            "name": item.product!.name,
            "price": item.product!.price,
            "size": item.size,
            "image": item.product!.images[0],
            "productId": item.product!.productId,
            "quantity": item.quantity,
          },
          onDelete: () async {
            bool? confirmed = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirm Deletion"),
                content: const Text("Are you sure you want to delete this item?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            );
            if (confirmed ?? false) {
              try {
                await OrderService().removeFromCart(item.product!.productId);
                onItemRemoved();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to delete item: $e")),
                );
              }
            }
          },
        );
      },
    );
  }
}

class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function onDelete;

  const CartItemTile({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shoe Image
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(item['image'], width: 80, height: 80),
          ),
          const SizedBox(width: 12),

          // Shoe Info + Quantity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("\$${item['price']}",
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 10),
                QuantitySelector(quantity: item['quantity']),
              ],
            ),
          ),

          // Size and Delete icon
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['size'],
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 32),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.black54),
                onPressed: () => onDelete(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;

  const QuantitySelector({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.remove, size: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text("$quantity", style: const TextStyle(fontSize: 16)),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor,
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class CheckoutSection extends StatelessWidget {
  final double totalAmount;

  const CheckoutSection({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _checkoutRow("Subtotal", "\$${totalAmount.toStringAsFixed(2)}"),
          const SizedBox(height: 8),
          _checkoutRow("Shipping", "\$40.90"),
          const Divider(height: 24, thickness: 1),
          _checkoutRow("Total Cost", "\$${(totalAmount + 40.90).toStringAsFixed(2)}", isBold: true, fontSize: 18),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: () => context.push(RouteNames.checkout),
              text: "Checkout",
            ),
          )
        ],
      ),
    );
  }

  Widget _checkoutRow(String label, String value, {bool isBold = false, double fontSize = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: fontSize)),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
