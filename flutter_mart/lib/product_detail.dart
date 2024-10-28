import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Product name and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Text(
                    'Product Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '\$315.95',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Product code and rating
            const Text(
              'Code: 573-635',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star_half, color: Colors.orange, size: 20),
                Icon(Icons.star_border, color: Colors.orange, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            // Product description
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Color and Size options
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Red', child: Text('Red')),
                      DropdownMenuItem(value: 'Blue', child: Text('Blue')),
                      DropdownMenuItem(value: 'Green', child: Text('Green')),
                    ],
                    onChanged: (value) {
                      // Handle color selection
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'S', child: Text('S')),
                      DropdownMenuItem(value: 'M', child: Text('M')),
                      DropdownMenuItem(value: 'L', child: Text('L')),
                    ],
                    onChanged: (value) {
                      // Handle size selection
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Add to Cart button
            ElevatedButton(
              onPressed: () {
                // Handle add to cart
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}