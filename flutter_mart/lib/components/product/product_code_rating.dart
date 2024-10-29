import 'package:flutter/material.dart';

class ProductCodeRating extends StatelessWidget {
  const ProductCodeRating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Code: 573-635',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.orange, size: 20),
            Icon(Icons.star, color: Colors.orange, size: 20),
            Icon(Icons.star, color: Colors.orange, size: 20),
            Icon(Icons.star_half, color: Colors.orange, size: 20),
            Icon(Icons.star_border, color: Colors.orange, size: 20),
          ],
        ),
      ],
    );
  }
}