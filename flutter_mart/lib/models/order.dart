// lib/models/order.dart
import 'cart.dart';

class Order {
  final String orderId;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String paymentId;
  final DateTime orderDate;
  final String paymentStatus; // e.g., "completed", "failed", "pending"
  final Map<String, String> shippingAddress;
  final String? contactEmail;
  final String? contactPhone;
  final String orderStatus; // This can be "completed", "cancelled", etc.

  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.paymentId,
    required this.orderDate,
    required this.paymentStatus,
    required this.shippingAddress,
    this.contactEmail,
    this.contactPhone,
    this.orderStatus = "pending", // Default status if not provided
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paymentId: json['paymentId'] ?? '',
      orderDate: DateTime.parse(json['orderDate'] ?? DateTime.now().toIso8601String()),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      shippingAddress: Map<String, String>.from(json['shippingAddress'] ?? {}),
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      orderStatus: json['orderStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'totalAmount': totalAmount,
    'paymentId': paymentId,
    'orderDate': orderDate.toIso8601String(),
    'paymentStatus': paymentStatus,
    'shippingAddress': shippingAddress,
    'contactEmail': contactEmail,
    'contactPhone': contactPhone,
    'orderStatus': orderStatus,
  };
}