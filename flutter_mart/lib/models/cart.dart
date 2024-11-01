class CartItem {
  final String productId;
  final int quantity;
  final double price;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'],
    quantity: json['quantity'],
    price: json['price'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'price': price,
  };
}

class Cart {
  final String userId;
  final List<CartItem> items;
  final double totalPrice;
  final double tax;
  final double discount;

  Cart({
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.tax,
    required this.discount,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    userId: json['userId'],
    items: (json['items'] as List)
        .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
        .toList(),
    totalPrice: json['totalPrice'].toDouble(),
    tax: json['tax'].toDouble(),
    discount: json['discount'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'totalPrice': totalPrice,
    'tax': tax,
    'discount': discount,
  };
}