import 'package:firebase_database/firebase_database.dart';
import '../models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {
  // Use the explicit region-specific URL to avoid mismatches
  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .refFromURL("https://flutter-mart-fa313-default-rtdb.asia-southeast1.firebasedatabase.app")
      .child('products');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addProduct(Product product) async {
    try {
      print("Saving product to Firebase: ${product.name}");
      await _dbRef.child(product.id).set(product.toJson());
      print("Product saved successfully: ${product.name}");
    } catch (error) {
      print("Error saving product: $error");
    }
  }

  Future<void> updateProduct(Product product) async {
    await _dbRef.child(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String productId) async {
    try {
      // Fetch the product details to get the images
      final productSnapshot = await _dbRef.child(productId).get();

      if (productSnapshot.exists) {
        final productData = productSnapshot.value as Map<dynamic, dynamic>;

        // Check if there is an images field and it is a list
        if (productData.containsKey('images') && productData['images'] is List) {
          List<dynamic> images = productData['images'];

          for (String imageUrl in images) {
            try {
              await _storage.refFromURL(imageUrl).delete();
              print('Deleted image from storage: $imageUrl');
            } catch (e) {
              print('Error deleting image $imageUrl: $e');
            }
          }
        }
      }

      // Finally, remove the product entry from the database
      await _dbRef.child(productId).remove();
      print('Product deleted successfully from database.');

    } catch (error) {
      print("Error deleting product: $error");
    }
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await _dbRef.get();
      print("Fetched data: ${snapshot.value}"); // Print raw data to debug

      if (snapshot.exists && snapshot.value is Map) {
        List<Product> products = [];

        // Explicitly cast snapshot.value to Map<dynamic, dynamic>
        final Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

        values.forEach((key, value) {
          print("Processing key: $key, value: $value"); // Debug print

          if (value is Map) {
            // Convert nested maps to Map<String, dynamic> recursively
            final Map<String, dynamic> productMap = convertNestedMapToDynamic(Map<String, dynamic>.from(value));

            // Add the product ID to the map as a string
            productMap['id'] = key.toString();

            print("Converted product map: $productMap"); // Debug print

            // Create and add Product object from the map
            products.add(Product.fromJson(productMap));
          } else {
            print("Unexpected data format for child: $value");
          }
        });

        return products;
      } else {
        print("No products found.");
        return [];
      }
    } catch (error) {
      print("Error fetching products: $error");
      return [];
    }
  }

// Helper function to recursively convert nested maps to Map<String, dynamic>
  Map<String, dynamic> convertNestedMapToDynamic(Map<String, dynamic> originalMap) {
    originalMap.forEach((key, value) {
      if (value is Map) {
        originalMap[key] = convertNestedMapToDynamic(Map<String, dynamic>.from(value));
      }
    });
    return originalMap;
  }
}