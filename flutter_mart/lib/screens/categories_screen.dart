import 'package:flutter/material.dart';
import '../components/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine device type (tablet or mobile) based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 3 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isTablet ? 1 : 0.75,
          ),
          itemCount: 6, // Example item count
          itemBuilder: (context, index) {
            // List of titles for the categories
            List<String> titles = [
              "WHAT'S NEW",
              "TOP WEAR",
              "FOOTWEAR",
              "ACCESSORIES",
              "SALE",
              "TRENDING"
            ];
            return CategoryCard(
              imageUrl: 'https://via.placeholder.com/300',
              title: titles[index % titles.length],
            );
          },
        ),
      ),
    );
  }
}