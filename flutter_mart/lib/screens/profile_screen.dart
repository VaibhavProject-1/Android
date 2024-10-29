import 'package:flutter/material.dart';
import '../components/profile/profile_avatar.dart';
import '../components/profile/profile_info.dart';
import '../components/profile/theme_switch_tile.dart';
import 'signup_login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const ProfileScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

  void handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignUpLoginScreen(toggleTheme: widget.toggleTheme)),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                    isDarkMode: isDarkMode,
                    onToggle: (value) {
                      setState(() {
                        isDarkMode = value;
                        widget.toggleTheme();
                      });
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