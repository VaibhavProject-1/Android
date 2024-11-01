import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Product> _filteredProducts = []; // Filtered list for search results

  List<Product> get products => _filteredProducts.isNotEmpty ? _filteredProducts : _products;

  Future<void> loadProducts() async {
    try {
      _products = await _productService.fetchProducts();
      _filteredProducts = []; // Reset filtered products
      notifyListeners();
    } catch (error) {
      print("Error loading products in provider: $error");
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = []; // Clear the search filter
    } else {
      final lowerCaseQuery = query.toLowerCase();
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(lowerCaseQuery) ||
            product.category.toLowerCase().contains(lowerCaseQuery) ||
            product.description.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    }
    notifyListeners(); // Notify listeners of the change
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

  // Group products by category (considering search results if any)
  Map<String, List<Product>> get productsByCategory {
    Map<String, List<Product>> groupedProducts = {};
    final productList = _filteredProducts.isNotEmpty ? _filteredProducts : _products;

    for (var product in productList) {
      if (!groupedProducts.containsKey(product.category)) {
        groupedProducts[product.category] = [];
      }
      groupedProducts[product.category]?.add(product);
    }
    return groupedProducts;
  }
}