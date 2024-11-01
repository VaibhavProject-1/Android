class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final Map<String, List<String>> variants;
  final String category;
  final int stock;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.variants,
    required this.category,
    required this.stock,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      images: List<String>.from(json['images'] ?? []),  // Explicitly casting to List<String>
      variants: (json['variants'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
          key,
          List<String>.from(value ?? []),  // Ensure each variant list is cast to List<String>
        ),
      ) ??
          {},  // Default to an empty map if variants are null
      category: json['category'] ?? '',
      stock: json['stock'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'images': images,
    'variants': variants,
    'category': category,
    'stock': stock,
    'rating': rating,
  };
}