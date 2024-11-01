//lib/providers/cart_provider.dart
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
    item.productId == product.id && item.variant == variant);

    if (existingCartItemIndex >= 0) {
      // If the item with the same variant already exists, increase the quantity
      _items[existingCartItemIndex] = CartItem(
        productId: _items[existingCartItemIndex].productId,
        name: _items[existingCartItemIndex].name,
        imageUrl: _items[existingCartItemIndex].imageUrl,
        quantity: _items[existingCartItemIndex].quantity + 1,
        price: _items[existingCartItemIndex].price,
        variant: _items[existingCartItemIndex].variant,
      );
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
      _items[itemIndex] = CartItem(
        productId: _items[itemIndex].productId,
        name: _items[itemIndex].name,
        imageUrl: _items[itemIndex].imageUrl,
        quantity: quantity,
        price: _items[itemIndex].price,
        variant: _items[itemIndex].variant, // Ensure variant is passed here
      );
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