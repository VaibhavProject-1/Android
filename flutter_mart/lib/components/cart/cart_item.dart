import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final String quantity;

  const CartItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          imageUrl,
          height: 60,
          width: 60,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 60);
          },
        ),
        title: Text(name),
        subtitle: Text(quantity),
        trailing: Text('\$$price'),
      ),
    );
  }
}