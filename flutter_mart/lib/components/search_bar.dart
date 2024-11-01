// lib/components/search_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class CustomSearchBar extends StatelessWidget {
  final bool isDarkMode;

  const CustomSearchBar({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBarColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];

    return TextField(
      onChanged: (query) {
        Provider.of<ProductProvider>(context, listen: false).searchProducts(query);
      },
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: searchBarColor,
      ),
    );
  }
}