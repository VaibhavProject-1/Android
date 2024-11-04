// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  double _totalPrice = 0.0;

  List<CartItem> get items => _items;
  double get totalPrice => _totalPrice;

  // Add a product with variant to the cart
  void addToCart(Product product, Map<String, String> variant) {
    final existingCartItemIndex = _items.indexWhere((item) =>
    item.productId == product.id && item.variant.toString() == variant.toString());

    if (existingCartItemIndex >= 0) {
      // Increment quantity if already exists
      _items[existingCartItemIndex].quantity += 1;
    } else {
      // Add a new item if it doesn't exist
      _items.add(
        CartItem(
          productId: product.id,
          name: product.name,
          imageUrl: product.images.first,
          quantity: 1,
          price: product.price,
          variant: variant,
        ),
      );
    }
    _calculateTotalPrice();
    notifyListeners();
  }

  // Remove a product from the cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _calculateTotalPrice();
    notifyListeners();
  }

  // Update the quantity of a cart item
  void updateItemQuantity(String productId, int quantity) {
    final itemIndex = _items.indexWhere((item) => item.productId == productId);

    if (itemIndex >= 0) {
      if (quantity > 0) {
        _items[itemIndex].quantity = quantity; // Update quantity
      } else {
        removeItem(productId); // Remove item if quantity is 0
      }
      _calculateTotalPrice();
      notifyListeners();
    }
  }

  // Update the total price of the cart
  void _calculateTotalPrice() {
    _totalPrice = _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Clear the cart
  void clearCart() {
    _items = [];
    _totalPrice = 0.0;
    notifyListeners();
  }
}