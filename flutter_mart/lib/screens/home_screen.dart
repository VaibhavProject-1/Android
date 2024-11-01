// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/search_bar.dart';
import '../components/banner_image.dart';
import '../components/new_arrival_grid.dart';
import '../providers/product_provider.dart';
import 'add_edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductProvider productProvider;

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterMart', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(isDarkMode: isDarkMode),
              const SizedBox(height: 20),
              const BannerImage(),
              const SizedBox(height: 20),
              const Text(
                'New Arrivals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return NewArrivalGrid(products: productProvider.products);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditProductScreen()),
          );
        },
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}