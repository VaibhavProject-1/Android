// lib/services/order_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/order.dart';

class OrderService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .refFromURL("https://flutter-mart-fa313-default-rtdb.asia-southeast1.firebasedatabase.app")
      .child('orders');

  Future<void> saveOrder(Order order) async {
    try {
      // Save the order directly without needing to set userId separately
      await _dbRef.child(order.orderId).set(order.toJson());
      print("Order saved successfully: ${order.orderId}");
    } catch (error) {
      print("Error saving order: $error");
    }
  }



  Future<List<Order>> fetchOrders(String userId) async {
    try {
      final snapshot = await _dbRef.orderByChild('userId').equalTo(userId).get();

      if (snapshot.exists && snapshot.value is Map) {
        List<Order> orders = [];
        final Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

        values.forEach((key, value) {
          if (value is Map) {
            final orderMap = Map<String, dynamic>.from(value);

            // Ensure items is a list or default to an empty list if null
            orderMap['items'] = (orderMap['items'] as List?)?.map((item) {
              return item != null ? Map<String, dynamic>.from(item as Map) : {};
            }).toList() ?? [];

            // Set the orderId explicitly
            orderMap['orderId'] = key.toString();

            // Add the Order instance to the orders list
            orders.add(Order.fromJson(orderMap));
          }
        });

        return orders;
      } else {
        print("No orders found for user $userId.");
        return [];
      }
    } catch (error) {
      print("Error fetching orders: $error");
      return [];
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _dbRef.child(orderId).update({'orderStatus': newStatus});
      print("Order status updated to: $newStatus");
    } catch (error) {
      print("Error updating order status: $error");
    }
  }
}