import 'package:flutter/material.dart';
import 'new_arrival_card.dart';

class NewArrivalGrid extends StatelessWidget {
  const NewArrivalGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: 4, // Replace with dynamic count if available
      itemBuilder: (context, index) {
        return const NewArrivalCard(
          imageUrl: 'https://via.placeholder.com/150',
          title: 'Taylor Plush 4-Piece Modular Chaise ...',
          color: '1 Color',
          price: 293.00,
        );
      },
    );
  }
}