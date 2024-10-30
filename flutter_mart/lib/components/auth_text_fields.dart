import 'package:flutter/material.dart';

class AuthTextFields extends StatelessWidget {
  final bool isSignUp;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;

  const AuthTextFields({
    Key? key,
    required this.isSignUp,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        if (isSignUp) const SizedBox(height: 16),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
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
        if (isSignUp) const SizedBox(height: 16),
        if (isSignUp)
          TextField(
            controller: TextEditingController(), // add a confirm password controller if needed
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
      ],
    );
  }
}