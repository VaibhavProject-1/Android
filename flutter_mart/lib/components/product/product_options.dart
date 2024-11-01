import 'package:flutter/material.dart';

class ProductOptions extends StatelessWidget {
  final Map<String, List<String>> options;
  final Map<String, String> selectedVariant;
  final Function(String, String) onVariantSelected;

  const ProductOptions({
    Key? key,
    required this.options,
    required this.selectedVariant,
    required this.onVariantSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.keys.map((variantType) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              variantType,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: options[variantType]!.map((option) {
                final isSelected = selectedVariant[variantType] == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  onSelected: (_) => onVariantSelected(variantType, option),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }
}