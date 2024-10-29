import 'package:flutter/material.dart';

class ToggleTextButton extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onTap;

  const ToggleTextButton({Key? key, required this.isSignUp, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        child: Text(
          isSignUp ? 'Already have an account? SIGN IN' : 'Don\'t have an account? SIGN UP',
          style: const TextStyle(decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}