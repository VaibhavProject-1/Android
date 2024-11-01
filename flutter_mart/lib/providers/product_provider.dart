import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> loadProducts() async {
    try {
      _products = await _productService.fetchProducts();
      print("Products loaded: $_products"); // Debug print
      notifyListeners();
    } catch (error) {
      print("Error loading products in provider: $error");
    }
  }

  Future<void> addProduct(Product product) async {
    print("Adding product: ${product.name}");
    await _productService.addProduct(product);
    _products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    await _productService.updateProduct(product);
    int index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    await _productService.deleteProduct(productId);
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}