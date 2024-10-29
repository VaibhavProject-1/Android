import 'package:flutter/material.dart';
import '../components/cart/cart_sidebar.dart';
import '../components/product/add_to_cart_button.dart';
import '../components/product/product_code_rating.dart';
import '../components/product/product_description.dart';
import '../components/product/product_image.dart';
import '../components/product/product_name_price.dart';
import '../components/product/product_options.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
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
            const ProductImage(),
            const SizedBox(height: 16),
            const ProductNamePrice(),
            const SizedBox(height: 8),
            const ProductCodeRating(),
            const SizedBox(height: 16),
            const ProductDescription(),
            const SizedBox(height: 16),
            const ProductOptions(),
            const SizedBox(height: 24),
            AddToCartButton(
              onPressed: () {
                // Handle add to cart
              },
            ),
          ],
        ),
      ),
    );
  }
}