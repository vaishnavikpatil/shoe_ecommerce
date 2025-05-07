import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/service/product_service.dart';
import 'package:shoe_ecommerce/service/order_service.dart';
import 'package:shoe_ecommerce/widgets/custom_scaffold.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final Map _productDetails = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future _loadProductDetails() async {
    try {
      for (var item in widget.order['items']) {
        final productId = item['product']['_id'];
        final product = await ProductService().getProductById(productId);
        _productDetails[productId] = product;
      }
    } catch (e) {
      print("Error loading product details: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _handleOrderUpdate(String orderId, Map<String, dynamic> updates) async {
    try {
      setState(() => _loading = true);
      await OrderService().updateOrder(orderId, updates);
      context.pop(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<OrderStep> steps = [
      OrderStep(
        title: 'Order Placed',
        subtitle: 'Your order has been placed',
        isCompleted: true,
        date: _formatDate(order['createdAt']),
      ),
      OrderStep(
        title: 'Order Accepted',
        subtitle: order['orderAcceptanceComment'] ?? 'Order confirmed',
        isCompleted: order['isOrderAccepted'] ?? false,
        date: order['isOrderAccepted'] ? _formatDate(order['updatedAt']) : null,
      ),
      OrderStep(
        title: 'Processing',
        subtitle: order['inProcessComment'] ?? 'Preparing your order',
        isCompleted: order['isInProcess'] ?? false,
        date: order['isInProcess'] ? _formatDate(order['updatedAt']) : null,
      ),
      OrderStep(
        title: 'In Transit',
        subtitle: order['inTransitComment'] ?? 'Your order is on the way',
        isCompleted: order['isInTransit'] ?? false,
        date: order['isInTransit'] ? _formatDate(order['updatedAt']) : null,
      ),
      OrderStep(
        title: 'Shipped',
        subtitle: order['shippedComment'] ?? 'Package is out for delivery',
        isCompleted: order['isShipped'] ?? false,
        date: order['isShipped'] ? _formatDate(order['updatedAt']) : null,
      ),
      OrderStep(
        title: 'Delivered',
        subtitle: order['deliveredComment'] ?? 'Package has been delivered',
        isCompleted: order['isDelivered'] ?? false,
        date: order['isDelivered'] ? _formatDate(order['updatedAt']) : null,
      ),
    ];

    return CustomScaffold(
      leadingIcon: Icons.arrow_back_ios,
      onLeadingTap: () => context.pop(),
      centerTitle: true,
      apptitle: "Order Details",
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Order Tracking'),
          OrderTrackingTimeline(steps: steps),
          const SizedBox(height: 24),

          _buildSectionTitle('Delivery Address'),
          _buildAddressCard(order['address']),
          const SizedBox(height: 24),

          _buildSectionTitle('Order Summary'),
          _buildOrderSummaryCard(order),
          const SizedBox(height: 24),

          if (!(order['isCancelled'] ?? false)) ...[
            if (!(order['isDelivered'] ?? false))
              _buildActionButton(
                label: 'Cancel Order',
                color: Colors.red,
                onPressed: () => _handleOrderUpdate(order['_id'], {
                  "status":"cancelled",
                  'isCancelled': true,
                  'cancelledComment': 'Order cancelled by user',
                }),
              ),
            if ((order['isDelivered'] ?? false)) ...[
              _buildActionButton(
                label: 'Return',
                color: Colors.orange,
                onPressed: () => _handleOrderUpdate(order['_id'], {
                  "status":"return requested",
                  'isReturnRequest': true,
                  'returnComment': 'Customer requested return',
                }),
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                label: 'Exchange',
                color: Colors.blueGrey,
                onPressed: () => _handleOrderUpdate(order['_id'], {
                  "status":"exchange requested",
                  'isExchangeRequest': true,
                  'exchangeComment': 'Customer requested exchange',
                }),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAddressCard(Map address) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 8),
              Text("Shipping Address", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(address['street'] ?? 'N/A'),
          if ((address['city'] ?? '').isNotEmpty) Text(address['city']),
          if ((address['state'] ?? '').isNotEmpty) Text(address['state']),
          if ((address['postalCode'] ?? '').isNotEmpty) Text(address['postalCode']),
          if ((address['country'] ?? '').isNotEmpty) Text(address['country']),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(Map order) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoRow("Order ID", "#${order['_id'].toString().substring(0, 8)}"),
          _infoRow("Order Date", _formatDate(order['createdAt'])),
          _infoRow("Payment Method", order['paymentMode']),
          const Divider(height: 24),
          _infoRow("Total Amount", "\$${order['totalAmount']}", isBold: true),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "N/A";
    }
  }
}

class OrderStep {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final String? date;

  OrderStep({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.date,
  });
}

class OrderTrackingTimeline extends StatelessWidget {
  final List<OrderStep> steps;

  const OrderTrackingTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(steps.length, (index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: step.isCompleted ? AppTheme.primaryColor : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: step.isCompleted
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: steps[index + 1].isCompleted ? Colors.blue : Colors.grey[300],
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: step.isCompleted ? Colors.black : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.subtitle,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        if (step.date != null) ...[
                          const SizedBox(height: 4),
                          Text(step.date!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
