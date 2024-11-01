import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/product/product_description.dart';
import '../components/product/product_image.dart';
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
            ProductImage(imageUrl: widget.product.images.first),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${widget.product.name} added to cart")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}