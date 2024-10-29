import 'package:flutter/material.dart';
import 'main_screen.dart';

class SignUpLoginScreen extends StatefulWidget {
  final VoidCallback toggleTheme; // Accept the toggleTheme callback

  const SignUpLoginScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  SignUpLoginScreenState createState() => SignUpLoginScreenState();
}

class SignUpLoginScreenState extends State<SignUpLoginScreen> {
  bool isSignUp = true; // Variable to track if we are showing the SignUp form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Sign Up / Login' : 'Login'),
        centerTitle: true,
        actions: [
          // Add a button to toggle theme
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme, // Call the toggleTheme method
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
            // Social Media Login Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    print('Facebook login pressed');
                  },
                  icon: const Icon(Icons.facebook),
                  iconSize: 40,
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () {
                    print('Google login pressed');
                  },
                  icon: const Icon(Icons.g_mobiledata),
                  iconSize: 40,
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    print('Twitter login pressed');
                  },
                  icon: const Icon(Icons.alternate_email),
                  iconSize: 40,
                  color: Colors.lightBlueAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            Text(
              isSignUp ? 'or using your E-mail' : 'Please Sign In',
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (isSignUp)
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            if (isSignUp) const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (isSignUp) const SizedBox(height: 16),
            if (isSignUp)
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isSignUp = !isSignUp;
                  });
                },
                child: Text(
                  isSignUp ? 'Already have an account? SIGN IN' : 'Don\'t have an account? SIGN UP',
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}