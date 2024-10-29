import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to determine if the device is a tablet
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600; // Treat screens wider than 600px as tablets

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 3 : 2, // 3 columns on tablets, 2 on mobile
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isTablet ? 1 : 0.75, // Square on tablets, rectangular on mobile
          ),
          itemCount: 6, // Increased item count to fill the screen better
          itemBuilder: (context, index) {
            // Sample titles for categories
            List<String> titles = [
              "WHAT'S NEW",
              "TOP WEAR",
              "FOOTWEAR",
              "ACCESSORIES",
              "SALE",
              "TRENDING"
            ];
            return buildCategoryCard(
                'https://via.placeholder.com/300',
                titles[index % titles.length] // Loop through titles for extra items
            );
          },
        ),
      ),
    );
  }

  Widget buildCategoryCard(String imageUrl, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background image with loading indicator
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.error, color: Colors.red, size: 48),
              ),
            ),
          ),
          // Dark overlay for text readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          // Title overlay at the bottom left
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}