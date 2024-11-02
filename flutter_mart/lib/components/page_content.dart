import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';
import '../screens/manage_product_screen.dart';  // Import the new ManageProductScreen
import '../screens/profile_screen.dart';

class PageContent extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  bool isDarkMode = false;

  PageContent() {
    // Initialize current user
    _auth.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  // Toggle theme method
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }

  // Pages to display based on authentication status
  List<Widget> get pages => [
    const HomeScreen(),
    const CartScreen(),
    ProfileScreen(toggleTheme: toggleTheme),
    const ManageProductScreen(),  // Use ManageProductScreen here
  ];
}