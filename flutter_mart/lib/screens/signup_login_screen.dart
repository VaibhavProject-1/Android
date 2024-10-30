import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/page_content.dart';
import '../components/social_media_buttons.dart';
import '../components/toggle_text_button.dart';
import 'main_screen.dart';

class SignUpLoginScreen extends StatefulWidget {
  @override
  SignUpLoginScreenState createState() => SignUpLoginScreenState();
}

class SignUpLoginScreenState extends State<SignUpLoginScreen> {
  bool isSignUp = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateToMainScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  Future<void> _signUpWithEmail() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign-Up Successful!")),
      );
      _navigateToMainScreen(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-Up Error: ${e.toString()}")),
      );
    }
  }

  Future<void> _loginWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );
      _navigateToMainScreen(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageContent = Provider.of<PageContent>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Sign Up / Login' : 'Login'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: pageContent.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              isSignUp ? 'Sign Up using Email' : 'Login with Email',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (isSignUp)
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            if (isSignUp) const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (isSignUp) const SizedBox(height: 8),
            if (isSignUp)
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (isSignUp) {
                  _signUpWithEmail();
                } else {
                  _loginWithEmail();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isSignUp ? 'SIGN UP' : 'SIGN IN'),
            ),
            const SizedBox(height: 24),
            const SocialMediaButtons(), // Social Media Buttons below fields
            const SizedBox(height: 16),
            ToggleTextButton(
              isSignUp: isSignUp,
              onTap: () => setState(() => isSignUp = !isSignUp),
            ),
          ],
        ),
      ),
    );
  }
}