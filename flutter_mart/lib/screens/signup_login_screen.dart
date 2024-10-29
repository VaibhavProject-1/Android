import 'package:flutter/material.dart';
import 'main_screen.dart';
import '../components/social_media_buttons.dart';
import '../components/auth_text_fields.dart';
import '../components/toggle_text_button.dart';

class SignUpLoginScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const SignUpLoginScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  SignUpLoginScreenState createState() => SignUpLoginScreenState();
}

class SignUpLoginScreenState extends State<SignUpLoginScreen> {
  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Sign Up / Login' : 'Login'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
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
            const Text(
              'Sign Up quickly using',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Social Media Buttons Component
            const SocialMediaButtons(),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            Text(
              isSignUp ? 'or using your E-mail' : 'Please Sign In',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Auth Text Fields Component
            AuthTextFields(isSignUp: isSignUp),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (!isSignUp) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(toggleTheme: widget.toggleTheme),
                    ),
                  );
                } else {
                  print('Sign Up pressed');
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
            const SizedBox(height: 16),
            // Toggle Text Button Component
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