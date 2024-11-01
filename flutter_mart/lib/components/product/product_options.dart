import 'package:flutter/material.dart';

class ProductOptions extends StatelessWidget {
  final Map<String, List<String>> options;

  const ProductOptions({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...options.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: entry.value.map((option) {
                  return ChoiceChip(
                    label: Text(option),
                    selected: false, // Update selection logic as needed
                    onSelected: (bool selected) {
                      // Handle option selection
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ],
    );
  }
}
