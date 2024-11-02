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
    // Get the screen width to determine the child aspect ratio dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2; // More columns on larger screens
    final childAspectRatio = screenWidth > 600 ? 1.5 : 0.9; // Adjust based on screen size

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return NewArrivalCard(
          product: product,
        );
      },
    );
  }
}