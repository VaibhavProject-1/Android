import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/profile/profile_avatar.dart';
import '../components/profile/profile_info.dart';
import '../components/profile/theme_switch_tile.dart';
import '../components/page_content.dart';
import 'signup_login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required void Function() toggleTheme}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  void handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignUpLoginScreen()), // Removed toggleTheme
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageContent = Provider.of<PageContent>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: pageContent.toggleTheme, // Directly toggle theme
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ProfileAvatar(),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ProfileInfo(
                    icon: Icons.person,
                    title: "My Profile",
                    onTap: () {
                      // Handle "My Profile" tap
                    },
                  ),
                  ProfileInfo(
                    icon: Icons.shopping_bag,
                    title: "My Orders",
                    onTap: () {
                      // Handle "My Orders" tap
                    },
                  ),
                  ThemeSwitchTile(
                    isDarkMode: pageContent.isDarkMode,
                    onToggle: (value) {
                      pageContent.toggleTheme(); // Access toggleTheme directly
                    },
                  ),
                  ProfileInfo(
                    icon: Icons.logout,
                    title: "Log Out",
                    onTap: () => handleLogout(context),
                    trailing: const Icon(Icons.logout, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}