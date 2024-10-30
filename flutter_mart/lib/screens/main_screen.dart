import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/page_content.dart';
import '../components/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageContent = Provider.of<PageContent>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterMart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: pageContent.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: pageContent.signOut,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pageContent.pages,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}