import 'package:flutter/material.dart';
import '../models/product.dart';
import '../components/cart/cart_sidebar.dart';
import '../components/product/add_to_cart_button.dart';
import '../components/product/product_code_rating.dart';
import '../components/product/product_description.dart';
import '../components/product/product_image.dart';
import '../components/product/product_name_price.dart';
import '../components/product/product_options.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: const Drawer(
        child: CartSidebar(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(imageUrl: product.images.first),
            const SizedBox(height: 16),
            ProductNamePrice(name: product.name, price: product.price),
            const SizedBox(height: 8),
            ProductCodeRating(code: product.id, rating: product.rating),
            const SizedBox(height: 16),
            ProductDescription(description: product.description),
            const SizedBox(height: 16),
            ProductOptions(options: product.variants), // Pass the variants to ProductOptions
            const SizedBox(height: 24),
            AddToCartButton(
              onPressed: () {
                // Handle add to cart functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}