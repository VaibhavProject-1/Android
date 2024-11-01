// lib/components/search_bar.dart
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final bool isDarkMode;
  final Function(String) onSearch;

  const CustomSearchBar({Key? key, required this.isDarkMode, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBarColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    return TextField(
      onChanged: onSearch, // Trigger search on text change
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