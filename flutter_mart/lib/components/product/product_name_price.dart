import 'package:flutter/material.dart';

class ProductNamePrice extends StatelessWidget {
  final String name;
  final double price;

  const ProductNamePrice({Key? key, required this.name, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          '\$$price',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}