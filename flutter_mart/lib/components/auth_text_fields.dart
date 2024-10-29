import 'package:flutter/material.dart';

class AuthTextFields extends StatelessWidget {
  final bool isSignUp;

  const AuthTextFields({Key? key, required this.isSignUp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}