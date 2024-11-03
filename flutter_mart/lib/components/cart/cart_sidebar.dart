import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../cart_item_tile.dart';

class CartSidebar extends StatelessWidget {
  const CartSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final theme = Theme.of(context);

    return Drawer(
      child: FractionallySizedBox(
        widthFactor: 0.95, // 80% of the screen width
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shopping Cart',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CartItemTile(
                        imageUrl: item.imageUrl,
                        name: "${item.name} - ${item.variant}", // Display variant with the name
                        price: item.price,
                        quantity: item.quantity,
                        onIncreaseQuantity: () {
                          cartProvider.updateItemQuantity(item.productId, item.quantity + 1);
                        },
                        onDecreaseQuantity: () {
                          if (item.quantity > 1) {
                            cartProvider.updateItemQuantity(item.productId, item.quantity - 1);
                          } else {
                            cartProvider.removeItem(item.productId);
                          }
                        },
                        onRemove: () {
                          cartProvider.removeItem(item.productId);
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).pushNamed('/cart'); // Navigate to CartScreen
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'PROCEED TO CHECKOUT',
                  style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the cart sidebar
                },
                child: Text(
                  'CONTINUE SHOPPING',
                  style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}