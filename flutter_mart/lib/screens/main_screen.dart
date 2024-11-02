import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../components/cart/cart_sidebar.dart';
import '../components/page_content.dart';
import '../components/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of titles for each page to display in the AppBar
  final List<String> _pageTitles = [
    'Home',
    'Cart',
    'Profile',
    'Manage Products',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Extend the app to the edges of the screen, blending the status bar with the AppBar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent
      statusBarIconBrightness: Brightness.dark, // Dark icons on light background
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pageContent = Provider.of<PageContent>(context);

    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Increase AppBar height for a notch effect
        child: AppBar(
          backgroundColor: Colors.transparent, // Transparent background for blend effect
          elevation: 0,
          title: Text(_pageTitles[_selectedIndex]), // Dynamic title based on the selected index
          centerTitle: true,
          automaticallyImplyLeading: true, // This will show the back button when needed
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: pageContent.toggleTheme,
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open the Cart Sidebar
                },
              ),
            ),
          ],
        ),
      ),
      endDrawer: const CartSidebar(),
      body: SafeArea( // SafeArea to keep contents within visible area and avoid notch overlap
        child: IndexedStack(
          index: _selectedIndex,
          children: pageContent.pages,
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}