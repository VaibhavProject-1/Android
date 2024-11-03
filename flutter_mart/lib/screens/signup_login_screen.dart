import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elegant_notification/elegant_notification.dart';
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
      ElegantNotification.error(
        title: const Text("Error"),
        description: const Text("Passwords do not match!"),
        toastDuration: const Duration(seconds: 3),
      ).show(context);
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ElegantNotification.success(
        title: const Text("Success"),
        description: const Text("Sign-Up Successful!"),
        toastDuration: const Duration(seconds: 3),
      ).show(context);
      _navigateToMainScreen(context);
    } catch (e) {
      ElegantNotification.error(
        title: const Text("Sign-Up Error"),
        description: Text(
          e.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        toastDuration: const Duration(seconds: 5),
      ).show(context);
    }
  }

  Future<void> _loginWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ElegantNotification.success(
        title: const Text("Success"),
        description: const Text("Login Successful!"),
        toastDuration: const Duration(seconds: 3),
      ).show(context);
      _navigateToMainScreen(context);
    } catch (e) {
      ElegantNotification.error(
        title: const Text("Login Error"),
        description: Text(
          e.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        toastDuration: const Duration(seconds: 5),
      ).show(context);
    }
  }

  Future<void> _resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ElegantNotification.info(
        title: const Text("Info"),
        description: const Text("Please enter your email to reset password."),
        toastDuration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ElegantNotification.success(
        title: const Text("Success"),
        description: const Text("Password reset email sent!"),
        toastDuration: const Duration(seconds: 3),
      ).show(context);
    } catch (e) {
      ElegantNotification.error(
        title: const Text("Error"),
        description: Text(
          e.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        toastDuration: const Duration(seconds: 5),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageContent = Provider.of<PageContent>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SafeArea(
        child: SingleChildScrollView(
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
              if (!isSignUp) const SizedBox(height: 8),
              if (!isSignUp)
                TextButton(
                  onPressed: _resetPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(decoration: TextDecoration.underline),
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
              const SocialMediaButtons(),
              const SizedBox(height: 16),
              ToggleTextButton(
                isSignUp: isSignUp,
                onTap: () => setState(() => isSignUp = !isSignUp),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}