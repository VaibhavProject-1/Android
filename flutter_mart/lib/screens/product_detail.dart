import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:getwidget/getwidget.dart'; // Import GetWidget
import 'package:elegant_notification/elegant_notification.dart';
import '../components/product/product_description.dart';
import '../components/product/product_name_price.dart';
import '../providers/cart_provider.dart';
import '../components/cart/cart_sidebar.dart';
import '../models/product.dart';
import '../components/product/add_to_cart_button.dart';
import '../components/product/product_options.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Map<String, String> selectedVariant = {};
  int currentIndex = 0;

  void _selectVariant(String variantType, String option) {
    setState(() {
      selectedVariant[variantType] = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
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
            // Product images carousel
            GFCarousel(
              items: widget.product.images.map((url) {
                return Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
                );
              }).toList(),
              autoPlay: true,
              viewportFraction: 1.0,
              aspectRatio: 16 / 9,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            const SizedBox(height: 8),
            // Pagination dots below the carousel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.product.images.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => setState(() {
                    currentIndex = entry.key;
                  }),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == entry.key
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ProductNamePrice(name: widget.product.name, price: widget.product.price),
            const SizedBox(height: 8),
            ProductDescription(description: widget.product.description),
            const SizedBox(height: 16),
            ProductOptions(
              options: widget.product.variants,
              selectedVariant: selectedVariant,
              onVariantSelected: _selectVariant,
            ),
            const SizedBox(height: 24),
            AddToCartButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).addToCart(
                  widget.product,
                  selectedVariant,
                );
                // Display ElegantNotification when product is added to cart
                ElegantNotification.success(
                  title: const Text("Success"),
                  description: Text("${widget.product.name} added to cart"),
                ).show(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}