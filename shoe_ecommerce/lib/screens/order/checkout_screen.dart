
import 'package:shoe_ecommerce/export.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderService _orderService = OrderService();
  bool isLoading = true;
  Cart cart = Cart();
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchCartItems();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('userEmail') ?? 'N/A';
      phone = prefs.getString('userPhone') ?? 'N/A';
    });
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

 Future<void> placeOrder() async {
  setState(() => isLoading = true);

  // Fetch address and payment method, assuming you have a fixed address and payment method for now.
  String address = "Newahall St 36, London, 12908 - UK";  // Replace with dynamic address if needed
  String paymentMode = "COD";  // Replace with dynamic payment method if needed

  try {
    // Call the checkout API and pass the necessary data
    final response = await _orderService.checkout(address, paymentMode);

    setState(() => isLoading = false);

  if (response['error'] == null) {
  showDialog(
    context: context,
    barrierDismissible: false, // Don't allow tap outside to dismiss
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("🎉",style: TextStyle(fontSize: 80.sp),),
            const SizedBox(height: 16),
            const Text(
              "Your Payment Is\nSuccessful",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                context.go(RouteNames.home, extra: 0); // Navigate to home
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  "Back To Shopping",
                  style: TextStyle(color: AppTheme.whiteColor),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
} 
 else {
      // Handle error if API returns an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: ${response['error']}")),
      );
    }
  } catch (e) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to place order: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cart.products == null || cart.products!.isEmpty) {
      return const Center(child: Text("Your cart is empty"));
    }

    return CustomScaffold(
      leadingIcon: Icons.arrow_back_ios,
      onLeadingTap: () => context.pop(),
      apptitle: "Checkout",
      centerTitle: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _sectionContainer(
                    children: [
                      const Text("Contact"),
                      SizedBox(height: 20.sp),
                      ContactInfoTile(icon: Icons.email_outlined, title: "Email", value: email),
                      SizedBox(height: 20.sp),
                      ContactInfoTile(icon: Icons.phone_outlined, title: "Phone", value: "+91 $phone"),
                    ],
                  ),
                  SizedBox(height: 20.sp),
                  _sectionContainer(
                    children: [
                      const Text("Address"),
                      SizedBox(height: 20.sp),
                      const AddressTile(address: "Newahall St 36, London, 12908 - UK"),
                    ],
                  ),
                  SizedBox(height: 20.sp),
                  _sectionContainer(
                    children: [
                      const Text("Payment Method"),
                      SizedBox(height: 20.sp),
                      const PaymentMethodTile(
                        cardType: "Paypal Card",
                        cardNumber: "**** **** 0696 4629",
                      ),
                    ],
                  ),
                  SizedBox(height: 20.sp),
                  _sectionContainer(
                    children: [
                      const Text("Products"),
                      SizedBox(height: 20.sp),
                      CartItemList(cart: cart, onItemRemoved: _fetchCartItems),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CheckoutSection(
            totalAmount: getTotalAmount(),
            onPlaceOrder: placeOrder,
          ),
        ],
      ),
    );
  }

  Widget _sectionContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
      ),
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ContactInfoTile({super.key, required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12.sp),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon),
        ),
        SizedBox(width: 10.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value),
            Text(title),
          ],
        )
      ],
    );
  }
}

class AddressTile extends StatelessWidget {
  final String address;

  const AddressTile({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address),
        SizedBox(height: 12.sp),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.sp),
          child: Image.asset(
            'assets/images/Map.png',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String cardType;
  final String cardNumber;

  const PaymentMethodTile({super.key, required this.cardType, required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12.sp),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/shoe1.png',
            width: 30,
            height: 30,
          ),
        ),
        SizedBox(width: 10.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cardType, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(cardNumber),
          ],
        )
      ],
    );
  }
}

class CartItemList extends StatelessWidget {
  final Cart cart;
  final VoidCallback onItemRemoved;

  const CartItemList({super.key, required this.cart, required this.onItemRemoved});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: cart.products!.map((item) {
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
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes")),
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
      }).toList(),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(item['image'], width: 40.sp, height: 40.sp),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("\$${item['price']}", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['size'], style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          )
        ],
      ),
    );
  }
}

class CheckoutSection extends StatelessWidget {
  final double totalAmount;
  final Future<void> Function() onPlaceOrder;

  const CheckoutSection({super.key, required this.totalAmount, required this.onPlaceOrder});

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
              onPressed: onPlaceOrder,
              text: "Place Order",
            ),
          ),
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
