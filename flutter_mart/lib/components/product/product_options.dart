import 'package:flutter/material.dart';

class ProductOptions extends StatelessWidget {
  const ProductOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Color',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Red', child: Text('Red')),
              DropdownMenuItem(value: 'Blue', child: Text('Blue')),
              DropdownMenuItem(value: 'Green', child: Text('Green')),
            ],
            onChanged: (value) {
              // Handle color selection
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Size',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'S', child: Text('S')),
              DropdownMenuItem(value: 'M', child: Text('M')),
              DropdownMenuItem(value: 'L', child: Text('L')),
            ],
            onChanged: (value) {
              // Handle size selection
            },
          ),
        ),
      ],
    );
  }
}