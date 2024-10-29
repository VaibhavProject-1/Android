import 'package:flutter/material.dart';

class SubtotalDisplay extends StatelessWidget {
  final double subtotal;
  final double deliveryCharge;

  const SubtotalDisplay({
    Key? key,
    required this.subtotal,
    required this.deliveryCharge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal', style: TextStyle(fontSize: 16)),
            Text('\$$subtotal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Delivery', style: TextStyle(fontSize: 16)),
            Text('\$$deliveryCharge', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}