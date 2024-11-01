import 'package:flutter/material.dart';

class CartSidebar extends StatelessWidget {
  const CartSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Cart Items',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        const ListTile(
          title: Text('Sample Product 1'),
          subtitle: Text('\$19.99'),
          trailing: Text('x1'),
        ),
        const ListTile(
          title: Text('Sample Product 2'),
          subtitle: Text('\$29.99'),
          trailing: Text('x2'),
        ),
        const Divider(),
        ElevatedButton(
          onPressed: () {
            // Proceed to checkout logic
          },
          child: const Text('Proceed to Checkout'),
        ),
      ],
    );
  }
}