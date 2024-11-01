class Order {
  final String id;
  final String userId;
  final Map<String, dynamic> products; // productId: {quantity, price}
  final double totalAmount;
  final String status;
  final String orderDate;
  final Map<String, dynamic> shippingAddress;

  Order({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    userId: json['userId'],
    products: json['products'],
    totalAmount: json['totalAmount'].toDouble(),
    status: json['status'],
    orderDate: json['orderDate'],
    shippingAddress: json['shippingAddress'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'products': products,
    'totalAmount': totalAmount,
    'status': status,
    'orderDate': orderDate,
    'shippingAddress': shippingAddress,
  };
}