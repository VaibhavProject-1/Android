// lib/providers/order_provider.dart
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<void> createOrder({
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
    required String paymentId,
    required Map<String, String> shippingAddress,
    required String paymentStatus,
    String? contactEmail,
    String? contactPhone,
  }) async {
    final newOrder = Order(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      paymentId: paymentId,
      orderDate: DateTime.now(),
      paymentStatus: paymentStatus,
      orderStatus: 'processing', // Set initial order status here
      shippingAddress: shippingAddress,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
    );

    _orders.add(newOrder);
    notifyListeners();

    // Optionally, save to Firebase or other backend service here
    // await FirebaseDatabase.instance.ref('orders/${newOrder.orderId}').set(newOrder.toJson());
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}