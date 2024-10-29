import 'package:flutter/material.dart';

class TotalDisplay extends StatelessWidget {
  final double total;

  const TotalDisplay({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('\$$total', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}