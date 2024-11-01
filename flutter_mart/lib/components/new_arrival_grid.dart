import 'package:flutter/material.dart';
import '../models/product.dart';
import 'new_arrival_card.dart';

class NewArrivalGrid extends StatelessWidget {
  final List<Product> products;

  const NewArrivalGrid({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: products.length, // Use dynamic product count
      itemBuilder: (context, index) {
        final product = products[index];
        return NewArrivalCard(
          product: product,
        );
      },
    );
  }
}