import 'package:flutter/material.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}