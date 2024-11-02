import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:elegant_notification/elegant_notification.dart';
import '../screens/main_screen.dart';

class SocialMediaButtons extends StatefulWidget {
  const SocialMediaButtons({Key? key}) : super(key: key);

  @override
  _SocialMediaButtonsState createState() => _SocialMediaButtonsState();
}

class _SocialMediaButtonsState extends State<SocialMediaButtons> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      ElegantNotification.error(
        title: const Text("Google Sign-In Failed"),
        description: Text("Failed to sign in with Google: $e"),
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        if (accessToken != null) {
          final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        ElegantNotification.info(
          title: const Text("Facebook Sign-In Cancelled"),
          description: const Text("Facebook sign-in was cancelled by the user."),
        ).show(context);
      } else {
        ElegantNotification.error(
          title: const Text("Facebook Sign-In Failed"),
          description: Text("Facebook sign-in failed: ${result.message}"),
        ).show(context);
      }
    } catch (e) {
      ElegantNotification.error(
        title: const Text("Facebook Sign-In Failed"),
        description: Text("Failed to sign in with Facebook: $e"),
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
      children: [
        ElevatedButton(
          onPressed: () => _signInWithGoogle(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/google.png',  // Using the local asset
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Sign up with Google',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => _signInWithFacebook(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.facebook,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Continue with Facebook',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}