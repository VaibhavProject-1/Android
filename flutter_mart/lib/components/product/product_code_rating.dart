import 'package:flutter/material.dart';

class ProductCodeRating extends StatelessWidget {
  final String code;
  final double rating;

  const ProductCodeRating({Key? key, required this.code, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Code: $code',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                if (index < rating.floor()) {
                  return const Icon(Icons.star, color: Colors.yellow, size: 20);
                } else if (index < rating && rating - index >= 0.5) {
                  return const Icon(Icons.star_half, color: Colors.yellow, size: 20);
                } else {
                  return const Icon(Icons.star_border, color: Colors.yellow, size: 20);
                }
              }),
            ),
            const SizedBox(width: 4), // Spacing between stars and rating number
            Text(
              rating.toStringAsFixed(1), // Display rating with one decimal place
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}