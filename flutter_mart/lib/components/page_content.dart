import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class PageContent {
  final VoidCallback toggleTheme;

  PageContent({required this.toggleTheme});

  List<Widget> get pages => [
    const HomeScreen(),
    const CategoriesScreen(),
    const CartScreen(),
    ProfileScreen(toggleTheme: toggleTheme),
  ];
}