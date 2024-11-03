import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:elegant_notification/elegant_notification.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String _selectedStatus;
  final OrderService _orderService = OrderService();
  final List<String> _statuses = ['Processing', 'Shipped', 'Delivered', 'Cancelled', 'Refunded'];

  @override
  void initState() {
    super.initState();

    // Initialize _selectedStatus with a valid value from _statuses
    if (_statuses.contains(widget.order.orderStatus)) {
      _selectedStatus = widget.order.orderStatus;
    } else {
      _selectedStatus = _statuses.first; // Default to the first status if there's a mismatch
    }
  }

  Future<void> _updateOrderStatus(String newStatus) async {
    await _orderService.updateOrderStatus(widget.order.orderId, newStatus);
    setState(() {
      _selectedStatus = newStatus;
    });
    // Show success notification using ElegantNotification
    ElegantNotification.success(
      title: const Text("Success"),
      description: Text("Order status updated to $newStatus"),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.order.orderId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Date: ${DateFormat('yMMMd').format(widget.order.orderDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Amount: \$${widget.order.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: _statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null && newStatus != _selectedStatus) {
                      _updateOrderStatus(newStatus);
                    }
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.order.items.length,
                itemBuilder: (context, index) {
                  final item = widget.order.items[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                    ),
                    title: Text(item.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${item.quantity}'),
                        Text('Variant: ${item.variant.entries.map((e) => "${e.key}: ${e.value}").join(', ')}'),
                        Text('Price: \$${item.price.toStringAsFixed(2)} each'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}