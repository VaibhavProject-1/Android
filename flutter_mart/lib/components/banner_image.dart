import 'package:flutter/material.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({Key? key}) : super(key: key);

  // Function to get the appropriate banner asset based on screen width
  String getBannerAsset(double width) {
    if (width <= 480) {
      return 'assets/banner1.jpg'; // Small Phones
    } else if (width <= 720) {
      return 'assets/banner2.jpg'; // Medium Phones
    } else if (width <= 1080) {
      return 'assets/banner3.png'; // Large Phones
    } else if (width <= 800) {
      return 'assets/banner4.jpg'; // Small Tablets
    } else if (width <= 1280) {
      return 'assets/banner5.jpg'; // Large Tablets
    } else if (width <= 1920) {
      return 'assets/banner6.jpg'; // Small Laptops and Desktops
    } else {
      return 'assets/banner7.jpg'; // Large Desktops
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final String bannerAsset = getBannerAsset(width);

    return Container(
      height: width / 2, // Maintain a 2:1 aspect ratio for height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(bannerAsset), // Use local asset instead of NetworkImage
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
