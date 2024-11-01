class CartItem {
  final String productId;
  final String name;       // Product name
  final String imageUrl;   // Image URL for display
  final int quantity;      // Quantity of the item
  final double price;      // Price per unit
  final Map<String, String> variant; // Selected variant options

  CartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.variant,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'],
    name: json['name'],
    imageUrl: json['imageUrl'],
    quantity: json['quantity'],
    price: json['price'].toDouble(),
    variant: Map<String, String>.from(json['variant'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'imageUrl': imageUrl,
    'quantity': quantity,
    'price': price,
    'variant': variant,
  };
}