import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final int quantity;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onRemove;

  const CartItemTile({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 60);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                  ),
                  Text('Price: \$${price.toStringAsFixed(2)}'),
                  Text('Quantity: x$quantity', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: onDecreaseQuantity,
                    ),
                    Text('$quantity'),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: onIncreaseQuantity,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onRemove,
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}