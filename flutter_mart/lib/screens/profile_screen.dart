import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mart/screens/signup_login_screen.dart';
import '../components/profile/profile_avatar.dart';
import '../components/profile/profile_info.dart';
import 'edit_profile_screen.dart';
import 'manage_addresses_screen.dart';
import 'change_password_screen.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const ProfileScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  // Remove the BuildContext parameter here
  void handleLogout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignUpLoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileAvatar(
              name: user?.displayName ?? 'Guest User',
              email: user?.email ?? 'guest@example.com',
              photoUrl: user?.photoURL,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ProfileInfo(
                    icon: Icons.person,
                    title: "Edit Profile",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                  ProfileInfo(
                    icon: Icons.location_on,
                    title: "Manage Addresses",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ManageAddressesScreen()),
                      );
                    },
                  ),
                  ProfileInfo(
                    icon: Icons.receipt_long,
                    title: "My Orders",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrdersScreen()),
                      );
                    },
                  ),
                  ProfileInfo(
                    icon: Icons.lock,
                    title: "Change Password",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                  ProfileInfo(
                    icon: Icons.brightness_6,
                    title: "Toggle Theme",
                    onTap: widget.toggleTheme,
                  ),
                  ProfileInfo(
                    icon: Icons.logout,
                    title: "Log Out",
                    onTap: handleLogout, // Call handleLogout directly
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