import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/page_content.dart';


class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MainScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("Tapped index: $index"); // Debugging to confirm tab updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: PageContent(toggleTheme: widget.toggleTheme).pages,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}